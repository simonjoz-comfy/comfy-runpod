#!/usr/bin/env bash

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup
# -e: exit on error
# -o pipefail: fail on any pipeline command error
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
set -eo pipefail

if [ -z "$NETWORK_VOLUME" ]; then
  NETWORK_VOLUME="/"
  MODELS_PATH="${COMFYUI_HOME%/}/models"
else
  MODELS_PATH="${NETWORK_VOLUME%/}/models"
fi

export NETWORK_VOLUME MODELS_PATH

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Create extra model paths directories
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
python -m pip install --no-cache-dir pyyaml && python - <<EOF
import yaml, os

comfy_home = os.environ["COMFYUI_HOME"]
network_volume = os.environ["NETWORK_VOLUME"]
extra_model_file_path = os.path.join(comfy_home, "extra_model_paths.yaml")

with open(extra_model_file_path) as f:
    data = yaml.safe_load(f)["comfyui"]
    paths = set()
    for v in data.values():
        if isinstance(v, str):
            for line in v.strip().splitlines():
                path = line.strip()
                if path:
                    os.makedirs(os.path.join(comfy_home, path), exist_ok=True)
                    os.makedirs(os.path.join(network_volume, path), exist_ok=True)
EOF

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Function Definitions
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
log_info() {
  echo -e "[INFO] $*"
}

log_warn() {
  echo -e "\033[1;33m[WARN] ⚠️ $*\033[0m"
}

log_error() {
  echo -e "\033[1;31m[ERROR] ❌ $*\033[0m"
}

execute_script() {
    local script_path=$1
    local script_msg=$2
    if [[ -f ${script_path} ]]; then
        log_info "${script_msg}"
        bash "${script_path}"
    fi
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Use tcmalloc for better memory management
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
setup_memory_optimization() {
    log_info "Setting up tcmalloc memory optimizations..."

    TCMALLOC="$(ldconfig -p | grep libtcmalloc_minimal.so | head -n1 | awk '{print $NF}')"
    if [[ -n "$TCMALLOC" ]]; then
        export LD_PRELOAD="$TCMALLOC"
        log_info "The tcmalloc set to: $TCMALLOC"
    else
        log_warn "The tcmalloc not found. Proceeding without LD_PRELOAD."
    fi
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup SSH
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
setup_ssh() {
    if [[ "$PUBLIC_KEY" ]]; then
        log_info "Public key detected. Setting up SSH..."

        mkdir -p ~/.ssh
        echo "$PUBLIC_KEY" >> ~/.ssh/authorized_keys
        chmod 700 -R ~/.ssh

        for key_type in rsa dsa ecdsa ed25519; do
            key_path="/etc/ssh/ssh_host_${key_type}_key"
            if [ ! -f "$key_path" ]; then
                ssh-keygen -t "$key_type" -f "$key_path" -q -N ''
                log_info "SSH ${key_type^^} key fingerprint:"
                ssh-keygen -lf "${key_path}.pub"
            fi
        done

        service ssh start

        log_info "SSH host keys:"

        for key in /etc/ssh/*.pub; do
            log_info "Key: $key"
            ssh-keygen -lf "$key"
        done
    else
        log_info "Public key not found. The SSH setup skipped."
    fi
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Export ENVS
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
export_env_vars() {
    log_info "Exporting environment variables..."

    printenv | grep -E '^RUNPOD_|^PATH=|^_=' | awk -F = '{ print "export " $1 "=\"" $2 "\"" }' >> /etc/rp_environment

    echo 'source /etc/rp_environment' >> ~/.bashrc
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Launch Jupiter
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
start_jupyter() {
    log_info "Starting Jupyter Lab..."

    nohup python -m jupyter lab --allow-root --no-browser --port=8888 \
    --ip=* --FileContentsManager.delete_to_trash=False \
    --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
    --ServerApp.token="$JUPYTER_PASSWORD" \
    --ServerApp.allow_origin=* \
    --ServerApp.preferred_dir="$NETWORK_VOLUME" &> /jupyter.log &

    log_info "Jupyter Lab started."
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Launch filebrowser
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
start_filebrowser() {
    log_info "Starting Filebrowser..."

    filebrowser -d "$NETWORK_VOLUME/filebrowser.db" config init

    if [ -z "$FB_USERNAME" ] || [ -z "$FB_PASSWORD" ]; then
      local no_auth_flag="--no-auth"
    else
      local no_auth_flag=""
      filebrowser -d "$NETWORK_VOLUME/filebrowser.db" users add "$FB_USERNAME" "$FB_PASSWORD" --perm.admin
    fi

    nohup filebrowser -d "$NETWORK_VOLUME/filebrowser.db" "$no_auth_flag" \
    --address 0.0.0.0 --port 4040 --root / > "$NETWORK_VOLUME/filebrowser.log" 2>&1 &

    log_info "Filebrowser started"
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Launch ComfyUI
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
start_comfyui() {
    log_info "Starting ComfyUI..."

    nohup comfy launch -- --listen 0.0.0.0 --port 3000 >> /dev/stdout 2>&1 &

    sleep 2
    if ! pgrep -f "comfy launch.*--port 3000" > /dev/null; then
         log_error "Failed to start ComfyUI" && exit 1
    fi

    log_info "ComfyUI started."
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Install ComfyUI Custom Nodes
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
install_comfyui_custom_nodes() {
  log_info "Installing Custom Nodes..."

  nodes=(
    "ComfyUI-GGUF@1.1.0"
    "ComfyUI-Crystools@1.22.1"
    "ComfyUI-JoyCaption@1.1.1"
    "ComfyUI-WanVideoWrapper@1.1.9"
    "comfyui_ultimatesdupscale@1.2.0"
    "comfyui-kjnodes@1.1.1"
    "rgthree-comfy@1.0.0"
    "comfyui-impact-pack@8.15.3"
    "comfyui-impact-subpack@1.3.2"
    "comfyui_controlnet_aux@1.0.7"
    "was-node-suite-comfyui@1.0.2"
    "comfyui_essentials@1.1.0"
    "comfyui-florence2@1.0.5"
    "comfyui_controlnet_aux@1.0.7"
    "comfyui_ipadapter_plus@2.0.0"
    "comfyui-image-saver@1.4.0"
    "comfyui-advancedliveportrait@1.0.0"
    "comfyui_pulid_flux_ll@1.1.4"
    "comfyui_faceanalysis@1.0.0"
    "comfyui-videohelpersuite@1.6.1"
    "comfyui-multigpu@1.7.3"
    "cg-use-everywhere@6.2.0"
    "comfyui-lama-remover@1.0.0"
    "comfyui-inspyrenet-rembg@1.1.1"
    "comfyui-detail-daemon@1.1.2"
    "teacache@1.6.1"
    "gguf@2.1.3"
    "x-flux-comfyui"
    "dreamo"
  )

  comfy node install "${nodes[@]}"

  log_info "Custom nodes installation completed."

  # Cleanup
  # ────────────────────────────────────────────────────────────────────────────────
  find "$COMFYUI_HOME/custom_nodes/" \( \
    -type d -name 'docs' -o \
    -type d -name 'tests' -o \
    -type d -name '__pycache__' -o \
    -type d -name '.git' -o \
    -type d -name '.github' -o \
    -type f -name '.gitignore' -o \
    -type f -name '.gitattributes' -o \
    -type f -name '.editorconfig' -o \
    -type f -name 'LICENSE' -o \
    -type f -name 'LICENSE.txt' -o \
    -type f -name 'CHANGELOG.md' \
  \) -exec rm -r {} +
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Models
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
download_all_models() {
    log_info "Models download started..."

    execute_script "/download-common.sh" "INFO: Running download-common script..."

    [[ "$DOWNLOAD_SDXL" == "true" ]] && execute_script "/download-sdxl.sh" "INFO: Downloading SDXL models..."
    [[ "$DOWNLOAD_FLUX" == "true" ]] && execute_script "/download-flux.sh" "INFO: Downloading Flux models..."
    [[ "$DOWNLOAD_WAN" == "true" ]] && execute_script "/download-wan.sh" "INFO: Downloading Wan 2.1 models..."
    [[ "$DOWNLOAD_HUNYUAN_DIT" == "true" ]] && execute_script "/download-hunyuan-dit.sh" "INFO: Downloading Hunyuan DiT models..."

    log_info "Models download completed"
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Main
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
log_info "Running startup script..."

setup_memory_optimization
export_env_vars
setup_ssh
start_jupyter
start_filebrowser
start_comfyui
download_all_models
execute_script "/post-start.sh" "INFO: Running /post-start.sh script..."

log_info "All startup scripts completed. Pod is ready to use."

sleep infinity
