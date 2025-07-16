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
VEA="$MODELS_PATH/vae"
CLIP="$MODELS_PATH/clip"
DIFFUSION_MODELS="$MODELS_PATH/diffusion_models"

mkdir -p "$CLIP" "$VEA" "$DIFFUSION_MODELS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Flux.1 Dev Kontext
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/vae/flux/ae.safetensors" "$VEA/ae.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip/clip_l.safetensors" "$CLIP/clip_l.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/clip/t5xxl_fp8_e4m3fn_scaled.safetensors" "$CLIP/t5xxl_fp8_e4m3fn_scaled.safetensors"
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/flux/flux1-dev-kontext_fp8_scaled.safetensors" "$DIFFUSION_MODELS/flux1-dev-kontext_fp8_scaled.safetensors"
