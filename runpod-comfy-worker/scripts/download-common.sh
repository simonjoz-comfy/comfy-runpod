#!/bin/bash

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

SAMS="$MODELS_PATH/sams"
SEGM="$MODELS_PATH/ultralytics/segm"
BBOXES="$MODELS_PATH/ultralytics/bbox"
UPSCALERS="$MODELS_PATH/upscale_models"

mkdir -p "$SAMS" "$SEGM" "$BBOXES" "$UPSCALERS"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Download Upscalers
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# 4x-Ultrasharp
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-UltraSharp.pth" "$UPSCALERS/4x-Ultrasharp.pth"

# 4x-ClearRealityV1
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-ClearRealityV1.pth" "$UPSCALERS/4x-ClearRealityV1.pth"

# 4x-ClearRealityV1_Soft
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-ClearRealityV1_Soft.pth" "$UPSCALERS/4x-ClearRealityV1_Soft.pth"

# 4x_NMKD-Superscale-SP_178000_G
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x_NMKD-Superscale-SP_178000_G.pth" "$UPSCALERS/4x_NMKD-Superscale-SP_178000_G.pth"

# 8x_NMKD-Faces_160000_G
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/8x_NMKD-Faces_160000_G.pth" "$UPSCALERS/8x_NMKD-Faces_160000_G.pth"

# 8xNMKDSuperscale_150000G
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/8xNMKDSuperscale_150000G.pt" "$UPSCALERS/8xNMKDSuperscale_150000G.pt"

# 4x_UniversalUpscalerV2-Sharp_101000_G
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x_UniversalUpscalerV2-Sharp_101000_G.pth" "$UPSCALERS/4x_UniversalUpscalerV2-Sharp_101000_G.pth"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# SAM
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# SAM VIT-L
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/sam/sam_vit_l_0b3195.pth" "$SAMS/sam_vit_l_0b3195.pth"


# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# BBOXs
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# Face
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/face_yolov9c.pt" "$BBOXES/face_yolov9c.pt"

# Eye
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/eyeful_individual_yolov8.pt" "$BBOXES/eyeful_individual_yolov8.pt"

# Lips
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/lips-v1.pt" "$BBOXES/lips-v1.pt"

# Hand
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/hand_yolov9c.pt" "$BBOXES/hand_yolov9c.pt"

# Female single breast
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/female-single-breast.pt" "$BBOXES/female-single-breast.pt"

# Female breasts
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/female-breasts-v4.7.pt" "$BBOXES/female-breasts-v4.7.pt"

# Buttocks
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/buttocks.pt" "$BBOXES/buttocks.pt"

# Vagina
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/vagina-v2.pt" "$BBOXES/vagina-v2.pt"

# Anus
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/anus-v3.pt" "$BBOXES/anus-v3.pt"

# NudeNet: lightweight Nudity detection
download_model "https://huggingface.co/SimonJoz/nudenet/resolve/main/320n.pt" "$BBOXES/nudenet-320n.pt"
download_model "https://huggingface.co/SimonJoz/nudenet/resolve/main/640m.pt" "$BBOXES/nudenet-640m.pt"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# SEGM
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
# face_bisenetv1_celebhq_79999
download_model "https://huggingface.co/SimonJoz/comfy/resolve/main/segm/face_bisenetv1_celebhq_79999.pth" "$SEGM/face_bisenetv1_celebhq_79999.pth"
