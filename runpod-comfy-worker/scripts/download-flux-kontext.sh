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
VEA="$MODELS_PATH/vae/flux"
UNET="$MODELS_PATH/unet/flux"
CHECKPOINTS="$MODELS_PATH/checkpoints/flux"

mkdir -p "$CLIP" "$VEA" "$UNET" "$CHECKPOINTS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Checkpoints
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux.1 Dev Kontext
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-kontext-dev.safetensors" "$CHECKPOINTS/flux1-kontext-dev.safetensors"
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-kontext-dev-Q8_0.gguf" "$UNET/flux1-kontext-dev-Q8_0.gguf"
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-dev-kontext_fp8_scaled.safetensors" "$CHECKPOINTS/flux1-dev-kontext_fp8_scaled.safetensors"

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

