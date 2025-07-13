# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Create ComfyUI Worker Image
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
ARG BASE_IMAGE="simonjoz/runpod-comfy-base:0.1.0-cuda12.6.3-ubuntu24.04"
FROM $BASE_IMAGE

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Install ComfyUI using CLI
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
ARG CUDA_VERSION="12.6"
ARG COMFYUI_HOME="/ComfyUI"
ARG COMFYUI_VERSION="0.3.42"
ARG PYTORCH_DOWNLOAD_URL="https://download.pytorch.org/whl/cu126"

ENV COMFYUI_HOME=$COMFYUI_HOME

RUN set -eux && \
    echo "INFO: Install PyTorch with CUDA support..." && \
    python -m pip install torch torchvision torchaudio --index-url $PYTORCH_DOWNLOAD_URL && \
    python -m pip hf_transfer && \
    echo "INFO: Installing ComfyUI..." && \
    comfy --workspace=$COMFYUI_HOME --skip-prompt install \
    --version $COMFYUI_VERSION --nvidia --cuda-version $CUDA_VERSION && \
    comfy set-default $COMFYUI_HOME && \
    comfy tracking disable && \
    comfy env && \
    echo "INFO: ComfyUI installation complete." && \
    # ──────────────────────────────────────────────────────────────────────────────────
    # ComfyUI Cleanup
    # ──────────────────────────────────────────────────────────────────────────────────
    cd $COMFYUI_HOME && \
    rm -rf .ci .github tests tests-unit notebooks script_examples  \
    .gitattributes .gitignore CODEOWNERS CONTRIBUTING.md LICENSE \
    extra_model_paths.yaml.example pytest.ini

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Copy ComfyUI configuration files
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
COPY ./configs/extra_model_paths.yaml $COMFYUI_HOME
COPY ./configs/comfy.settings.json "${COMFYUI_HOME}/user/default"

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Copy ComfyUI workflows files
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
COPY ./workflows/ "${COMFYUI_HOME}/user/default/workflows/"

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Copy notebooks
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
COPY ./ipynb /ipynb

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Copy all scripts
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
COPY --chmod=755 ./scripts/download-model.sh /
COPY --chmod=755 ./scripts/download-common.sh /
COPY --chmod=755 ./scripts/download-hunyuan-dit.sh /
COPY --chmod=755 ./scripts/download-sdxl.sh /
COPY --chmod=755 ./scripts/download-flux.sh /
COPY --chmod=755 ./scripts/download-flux-kontext.sh /
COPY --chmod=755 ./scripts/download-wan.sh /
COPY --chmod=755 ./scripts/start.sh /

CMD ["/start.sh"]
