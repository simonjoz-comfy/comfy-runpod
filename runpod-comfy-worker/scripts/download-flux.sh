#!/usr/bin/env bash

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup
# -e: exit on error
# -u: error on unset variables
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
set -eu

source /download-model.sh

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Create DIRs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

CLIP="$MODELS_PATH/clip"
PULID="$MODELS_PATH/pulid"
VEA="$MODELS_PATH/vae/flux"
UNET="$MODELS_PATH/unet/flux"
LORAS="$MODELS_PATH/loras/flux"
UPSCALERS="$MODELS_PATH/upscale_models"
CONTROL_NET="$MODELS_PATH/controlnet/flux"
CHECKPOINTS="$MODELS_PATH/checkpoints/flux"
CLIP_VISION="$MODELS_PATH/clip_vision/flux"
XLABS_IP_ADAPTERS="$COMFYUI_HOME/models/xlabs/ipadapters"

mkdir -p "$CLIP" "$PULID" "$VEA" "$UNET" "$LORAS" "$UPSCALERS" \
"$CONTROL_NET" "$CHECKPOINTS" "$CLIP_VISION" "$XLABS_IP_ADAPTERS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Checkpoints
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux.1 Dev
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-dev.safetensors" "$UNET/flux1-dev.safetensors"

# Flux.1 Dev - fp8
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-dev-fp8.safetensors" "$CHECKPOINTS/flux1-dev-fp8.safetensors"

# Flux.1 Dev Q8_0 GGUF
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-dev-Q8_0.gguf" "$UNET/flux1-dev-Q8_0.gguf"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# VAEs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux AE VAE
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/vae/flux/ae.safetensors" "$VEA/ae.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# CLIPs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# CLIP-L
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip/clip_l.safetensors" "$CLIP/clip_l.safetensors"

# T5-XXL - fp16
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip/t5xxl_fp16.safetensors" "$CLIP/t5xxl_fp16.safetensors"

# T5-XXL - fp8
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip/t5xxl_fp8_e4m3fn_scaled.safetensors" "$CLIP/t5xxl_fp8_e4m3fn_scaled.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# LoRAs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Turbo 8 steps LoRA
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/flux/flux-turbo-alpha-lora.safetensors" "$LORAS/flux-turbo-alpha-lora.safetensors"

# Flux Depth LoRA
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/flux/flux1-depth-dev-lora.safetensors" "$LORAS/flux1-depth-dev-lora.safetensors"

# Xlabs AI Photo-Realism
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/flux/flux_realism_lora_comfy_converted.safetensors" "$LORAS/flux_realism_lora.safetensors"

# Photorealistic Skin
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/flux/flux-realistic-skin-lora-v0.1.safetensors" "$LORAS/flux-realistic-skin-lora-v0.1.safetensors"

# Hourglass Body
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/flux/hourglass-body-flux.safetensors" "$LORAS/hourglass-body-flux.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# DreamO LoRAs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
download_model "https://huggingface.co/SimonJoz/comfy-dreamo/resolve/main/dreamo_comfyui.safetensors" "$LORAS/dreamo_comfyui.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy-dreamo/resolve/main/dreamo_cfg_distill_comfyui.safetensors" "$LORAS/dreamo_cfg_distill_comfyui.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy-dreamo/resolve/main/dreamo_quality_lora_pos_comfyui.safetensors" "$LORAS/dreamo_quality_lora_pos_comfyui.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy-dreamo/resolve/main/dreamo_quality_lora_neg_comfyui.safetensors" "$LORAS/dreamo_quality_lora_neg_comfyui.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# ControlNets
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux HED v3
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/control-net/flux/flux-hed-controlnet-v3.safetensors" "$CONTROL_NET/flux-hed-controlnet-v3.safetensors"

# Flux Depth v3
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/control-net/flux/flux-depth-controlnet-v3.safetensors" "$CONTROL_NET/flux-depth-controlnet-v3.safetensors"

# InstantX Union
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/control-net/flux/flux-union-instantx-controlnet.safetensors" "$CONTROL_NET/flux-union-instantx-controlnet.safetensors"

# ShakkerLabs Union Pro 2.0
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/control-net/flux/flux-dev-shakker-labs-controlnet-union-pro-2.0" "$CONTROL_NET/flux-dev-shakker-labs-controlnet-union-pro-2.0"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# IP Adapters
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux XLabs IP Adapter v2
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/ip-adapter/flux/ip_adapter_v2.safetensors" "$XLABS_IP_ADAPTERS/ip_adapter_v2.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Clip vision
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# CLIP-VIT-L
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip-vision/clip-vit-large-patch14.safetensors" "$CLIP_VISION/clip-vit-large-patch14.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# PuLID
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux PulID v0.9.1
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/pulid/pulid_flux_v0.9.1.safetensors" "$PULID/pulid_flux_v0.9.1.safetensors"
