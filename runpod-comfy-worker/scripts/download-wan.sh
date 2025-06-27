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

VEA="$MODELS_PATH/vae/wan"
UNET="$MODELS_PATH/unet/wan"
LORAS="$MODELS_PATH/loras/wan"
CLIP_VISION="$MODELS_PATH/clip_vision/wan"
TEXT_ENCODERS="$MODELS_PATH/text_encoders/wan"

mkdir -p "$VEA" "$UNET" "$LORAS" "$CLIP_VISION" "$TEXT_ENCODERS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Checkpoints
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

# 14.5 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/wan_vace_v2v/Wan2.1_T2V_14B_FusionX_VACE-Q6_K.gguf" "$UNET/Wan2.1_T2V_14B_FusionX_VACE-Q6_K.gguf"

# 18.7 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/wan_vace_v2v/Wan2.1_T2V_14B_FusionX_VACE-Q8_0.gguf" "$UNET/Wan2.1_T2V_14B_FusionX_VACE-Q8_0.gguf"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download LoRAs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

# 205 MB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/lora/Wan21_CausVid_14B_T2V_lora_rank32_v2.safetensors" "$LORAS/Wan21_CausVid_14B_T2V_lora_rank32_v2.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download VEAs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

# 254 MB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/vae/wan_2.1_vae.safetensors" "$VEA/wan_2.1_vae.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Text Encoders
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

# 6.04 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/text_encoders/umt5-xxl-encoder-Q8_0.gguf" "$TEXT_ENCODERS/umt5-xxl-encoder-Q8_0.gguf"

# 6.74 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" "$TEXT_ENCODERS/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# 11.4 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/text_encoders/umt5_xxl_fp16.safetensors" "$TEXT_ENCODERS/umt5_xxl_fp16.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Clip Vision
# ──────────────────────────────────────────────────────────────────────────────────────────────────────

# 1.26 GB
download-model "https://huggingface.co/SimonJoz/wan-2.1/resolve/main/clip_vision/clip_vision_h.safetensors" "$CLIP_VISION/clip_vision_h.safetensors"
