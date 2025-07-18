#!/usr/bin/env bash

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup
# -e: exit on error
# -o pipefail: fail on any pipeline command error
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
set -eo pipefail

COMFY_DEFAULT_MODELS_PATH="${COMFYUI_HOME%/}/models"
COMFY_DEFAULT_OUTPUTS_PATH="${COMFYUI_HOME%/}/output"

if [ -z "$NETWORK_VOLUME" ]; then
  NETWORK_VOLUME="/"
  MODELS_PATH="${COMFY_DEFAULT_MODELS_PATH}"
  OUTPUTS_PATH="${COMFY_DEFAULT_OUTPUTS_PATH}"
else
  MODELS_PATH="${NETWORK_VOLUME%/}/models"
  OUTPUTS_PATH="${NETWORK_VOLUME%/}/output"
fi

export NETWORK_VOLUME MODELS_PATH OUTPUTS_PATH

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
    if [ -n "$TCMALLOC" ]; then
        export LD_PRELOAD="$TCMALLOC"
        log_info "✅ The tcmalloc set to: $TCMALLOC"
    else
        log_warn "The tcmalloc not found. Proceeding without LD_PRELOAD."
    fi
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup SSH
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
setup_ssh() {
    if [ -n "$PUBLIC_KEY" ] && [ "$PUBLIC_KEY" != "null" ]; then
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

    python -m jupyter lab --allow-root --no-browser --port=8888 \
    --ip=* --FileContentsManager.delete_to_trash=False \
    --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
    --ServerApp.token="$JUPYTER_PASSWORD" \
    --ServerApp.allow_origin=* \
    --ServerApp.preferred_dir="$NETWORK_VOLUME" &> /jupyter.log &

    log_info "✅ Jupyter Lab started."
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Launch filebrowser
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
start_filebrowser() {
    log_info "Starting Filebrowser..."

    local fb_db_path="$NETWORK_VOLUME/filebrowser.db"
    local fb_logs_path="$NETWORK_VOLUME/filebrowser.log"

    rm -f "$fb_db_path"

    filebrowser -d "$fb_db_path" config init

    if [ -z "$FB_USERNAME" ] || [ -z "$FB_PASSWORD" ]; then
        filebrowser -d "$fb_db_path" config set --auth.method=noauth
        log_warn "Starting Filebrowser with no authentication."
    else
        filebrowser -d "$fb_db_path" config set --minimum-password-length=4
        filebrowser -d "$fb_db_path" users add "$FB_USERNAME" "$FB_PASSWORD" --perm.admin
    fi

    filebrowser -d "$fb_db_path" --address 0.0.0.0 --port 4040 --root / > "$fb_logs_path" 2>&1 &
    log_info "✅ Filebrowser started"
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Launch ComfyUI
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
start_comfyui() {
    log_info "Starting ComfyUI..."

    if [ "$OUTPUTS_PATH" != "$COMFY_DEFAULT_OUTPUTS_PATH" ]; then

      mkdir -p "$OUTPUTS_PATH"

      # If not a symlink, or doesn't exist at all, fix it
      if [ ! -L "$COMFY_DEFAULT_OUTPUTS_PATH" ]; then
          log_info "Creating outputs symlink..."

          # Remove default Comfy output directory if exists
          rm -rf "$COMFY_DEFAULT_OUTPUTS_PATH"

          # Create symlink
          ln -s "$OUTPUTS_PATH" "$COMFY_DEFAULT_OUTPUTS_PATH"
          log_info "✅ Created symlink: $OUTPUTS_PATH -> $COMFY_DEFAULT_OUTPUTS_PATH"
      fi
    fi

    comfy launch -- --listen 0.0.0.0 --port 3000 >> /dev/stdout 2>&1 &

    sleep 2
    if ! pgrep -f "comfy launch.*--port 3000" > /dev/null; then
         log_error "Failed to start ComfyUI" && exit 1
    fi

    log_info "✅ ComfyUI started."
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Install ComfyUI Custom Nodes
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
install_comfyui_custom_nodes() {
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
    "comfyui-easy-use@1.3.0"
    "efficiency-nodes-comfyui@1.0.7"
    "comfyui-custom-scripts@1.2.5"
    "comfyui-reactor@0.6.0"
  )

  if [ -n "$CUSTOM_NODES_LIST" ]; then
      IFS=',' read -r -a nodes <<< "$CUSTOM_NODES_LIST"
      log_info "Custom nodes list detected. Installing configured nodes: ${nodes[*]}"
  else
      log_info "Installing Default Custom Nodes: ${nodes[*]}"
  fi

  for node in "${nodes[@]}"; do
      echo "Installing $node"
      comfy node install "$node"
  done

  log_info "✅ Custom nodes installation completed."

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
wait_for_download_completion() {
  local model_type=$1
  while pgrep -x "aria2c" > /dev/null; do
    echo "INFO: Downloading $model_type models in progress..."
    sleep 5
  done
}

download_all_models() {
    log_info "Models download started..."

    execute_script "/download-common.sh" "INFO: Running download-common script..."
    wait_for_download_completion "common"

    if [ "$DOWNLOAD_SDXL" == "true" ]; then
      execute_script "/download-sdxl.sh" "INFO: Downloading SDXL models..."
      wait_for_download_completion "SDXL"
    else
      log_info "DOWNLOAD_SDXL = $DOWNLOAD_SDXL. Skipping..."
    fi

    if [ "$DOWNLOAD_FLUX" == "true" ]; then
      execute_script "/download-flux.sh" "INFO: Downloading Flux models..."
      wait_for_download_completion "Flux"
    else
      log_info "DOWNLOAD_FLUX = $DOWNLOAD_FLUX. Skipping..."
    fi

    if [ "$DOWNLOAD_FLUX_KONTEXT" == "true" ]; then
      execute_script "/download-flux-kontext.sh" "INFO: Downloading Flux Kontext models..."
      wait_for_download_completion "Flux Kontext"
    else
      log_info "DOWNLOAD_FLUX_KONTEXT = $DOWNLOAD_FLUX. Skipping..."
    fi

    if [ "$DOWNLOAD_WAN" == "true" ]; then
      execute_script "/download-wan.sh" "INFO: Downloading Wan 2.1 models..."
      wait_for_download_completion "Wan 2.1"
    else
      log_info "DOWNLOAD_WAN = $DOWNLOAD_WAN. Skipping..."
    fi

    if [ "$DOWNLOAD_HUNYUAN_DIT" == "true" ]; then
      execute_script "/download-hunyuan-dit.sh" "INFO: Downloading Hunyuan DiT models..."
      wait_for_download_completion "Hunyuan DiT"
    else
      log_info "DOWNLOAD_HUNYUAN_DIT = $DOWNLOAD_HUNYUAN_DIT. Skipping..."
    fi

    wait_for_download_completion ""
    log_info "✅ Models download completed"
}

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Main
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
log_info "Running startup script..."

setup_ssh
export_env_vars
setup_memory_optimization

start_jupyter
start_filebrowser

install_comfyui_custom_nodes
download_all_models
start_comfyui

log_info "✅ All startup scripts completed. Pod is ready to use."

sleep infinity
