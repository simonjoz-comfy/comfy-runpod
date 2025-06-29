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

VEA="$MODELS_PATH/vae/sdxl"
LORAS="$MODELS_PATH/loras/sdxl"
INSIGHT_FACE="$MODELS_PATH/insightface"
INSTANT_ID="$MODELS_PATH/instantid/sdxl"
EMBEDDINGS="$MODELS_PATH/embeddings/sdxl"
CONTROL_NET="$MODELS_PATH/controlnet/sdxl"
CHECKPOINTS="$MODELS_PATH/checkpoints/sdxl"

mkdir -p "$VEA" "$LORAS" "$INSIGHT_FACE" "$INSTANT_ID" "$EMBEDDINGS" "$CONTROL_NET" "$CHECKPOINTS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Base SDXL
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/vae/sdxl/sdxl-vae.safetensors" "$VAE/sdxl-vae.safetensors"
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/sdxl-base-1.0.safetensors" "$CHECKPOINTS/sdxl-base-1.0.safetensors"
#download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/sdxl-refiner-1.0.safetensors" "$CHECKPOINTS/sdxl-refiner-1.0.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Realistic Checkpoints
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Juggernaut XL By RunDiffusion
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/juggernaut-sdxl-by-run-diffusion.safetensors" "$CHECKPOINTS/juggernaut-sdxl-by-run-diffusion.safetensors"

# epiCRealism XL vXVI - LastFAME (Realism)
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/epicrealism-sdxl-vxvi-lastfame-realism.safetensors" "$CHECKPOINTS/epicrealism-sdxl-vxvi-lastfame-realism.safetensors"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Realistic NSFW Checkpoints
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Big Lust v1.6
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/big-lust-v1.6.safetensors" "$CHECKPOINTS/big-lust-v1.6.safetensors"

# Big Love v2.5
download_model  "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/big-love-sdxl-v2.5.safetensors" "$CHECKPOINTS/big-love-sdxl-v2.5.safetensors"

# Realism By Stable Yogi v5-xl FP16
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/realism-by-stable-yogi-v5-xl-fp16.safetensors" "$CHECKPOINTS/realism-by-stable-yogi-v5-xl-fp16.safetensors"

# Realism By Stable Yogi v5-xl FP32
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/checkpoint/sdxl/realism-by-stable-yogi-v5-xl-fp32.safetensors" "$CHECKPOINTS/realism-by-stable-yogi-v5-xl-fp32.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Embeddings
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# NEGATIVE_HANDS
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/embeddings/sdxl/NEGATIVE_HANDS.safetensors" "$EMBEDDINGS/NEGATIVE_HANDS.safetensors"

# Stable_Yogis_PDXL_Positives
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/embeddings/sdxl/Stable_Yogis_PDXL_Positives.safetensors" "$EMBEDDINGS/Stable_Yogis_PDXL_Positives.safetensors"

# Stable_Yogis_PDXL_Negatives
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/embeddings/sdxl/Stable_Yogis_PDXL_Negatives-neg.safetensors" "$EMBEDDINGS/Stable_Yogis_PDXL_Negatives-neg.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# LoARs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# DMD2 4-Step Speed
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/dmd2-sdxl-4step-lora-fp16.safetensors" "$LORAS/dmd2-sdxl-4step-lora-fp16.safetensors"

# Detail Tweaker XL
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/add-detail-sdxl-lora.safetensors" "$LORAS/add-detail-sdxl-lora.safetensors"

# Better faces
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/better-faces-sdxl-lora-v1.safetensors" "$LORAS/better-faces-sdxl-lora-v1.safetensors"

# Hourglass Body Shape
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/hourglass-v2-sdxl-lora.safetensors" "$LORAS/hourglass-v2-sdxl-lora.safetensors"

# Perfect Round Ass
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/round-ass-v1.1-sdxl-lora.safetensors" "$LORAS/round-ass-v1.1-sdxl-lora.safetensors"

# Big Round Butt
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/big-round-butt-sdxl-lora.safetensors" "$LORAS/big-round-butt-sdxl-lora.safetensors"

# Dumptruck Booty - Experimental
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/dumpy-ass-sdxl-lora.safetensors" "$LORAS/dumpy-ass-sdxl-lora.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# NSFW LoRAs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Subtle UltraRes
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/subtle-ultrares-v1-sdxl-big-love-2.5.safetensors" "$LORAS/subtle-ultrares-v1-sdxl-big-love-2.5.safetensors"

# No Bra SDXL
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/no-bra-v1-sdxl-lora.safetensors" "$LORAS/no-bra-v1-sdxl-lora.safetensors"

# Detailed nipples XL
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/detailed-nipples-sdxl-lora.safetensors" "$LORAS/detailed-nipples-sdxl-lora.safetensors"

# NSFW POV All In One SDXL
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/lora/sdxl/nsfw-pov-all-in-one-lora-sdxl-000009.safetensors" "$LORAS/nsfw-pov-all-in-one-lora-sdxl-000009.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# ControlNets
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Controlnet Union ProMax
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/control-net/sdxl/controlnet-union-sdxl-1.0-promax.safetensors" "$CONTROL_NET/controlnet-union-sdxl-1.0-promax.safetensors"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Instant ID
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# InstantID IP Adapter face id plus v2
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/instantid/sdxl/ip-adapter-faceid-plusv2-sdxl.bin" "$INSTANT_ID/ip-adapter-faceid-plusv2-sdxl.bin"

# InsightFace
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/insightface/antelopev2.zip" "$INSIGHT_FACE/antelopev2.zip"

# Get the last background PID
download_pid=$!

# Wait for it to finish
wait "$download_pid"

# unzip
unzip "$INSIGHT_FACE/antelopev2.zip" -d "$INSIGHT_FACE/models/"
