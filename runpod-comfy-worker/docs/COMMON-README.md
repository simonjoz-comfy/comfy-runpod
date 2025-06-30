# Common Resource List

---

## 🧰 Upscalers

| Upscaler                              | File name                                 | Size    | Details                                                                                                                                                                                                                                                                                        | Download                                                                                                           |
|---------------------------------------|-------------------------------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| 4x-UltraSharp                         | 4x-UltraSharp.pth                         | 67 MB   | Pros: Balanced sharpness vs. over-detail; neutral color reproduction; fast inference; low VRAM footprint.<br/>Cons: Ghosted edges; double-lines on curves; can over-smooth micro-textures.<br/>Use When: You need a quick, versatile all-rounder with crisp detail on most content (low VRAM). | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-UltraSharp.pth)                         |
| 4x-ClearRealityV1                     | 4x-ClearRealityV1.pth                     | 9.02 MB | Pros: Natural, artifact-free output optimized for faces, hair, and landscapes.<br/>Cons: Struggles on grainy or heavily blurred inputs; artifacts in strong DOF/bokeh scenes.<br/>Use When: Your source is already clean and you want realistic rendering of portraits or nature shots.        | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-ClearRealityV1.pth)                     |
| 4x-ClearRealityV1_Soft                | 4x-ClearRealityV1_Soft.pth                | 9.02 MB | Pros: Even softer gradients and smooth transitions, ideal for a gentle finish.<br/>Cons: Can lose micro-texture and look “painted” in highly detailed scenes.<br/>Use When: Final smoothing pass to remove minor artifacts in realistic renders.                                               | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x-ClearRealityV1_Soft.pth)                |
| 4x_NMKD-Superscale-SP_178000_G        | 4x_NMKD-Superscale-SP_178000_G.pth        | 67 MB   | Pros: Highly realistic detail preservation; strong fidelity for SDXL content.<br/>Cons: Tendency to oversharpen (“bitty” textures); slight desaturation.<br/>Use When: Photorealistic 4× upscaling where fidelity is your top priority.                                                        | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x_NMKD-Superscale-SP_178000_G.pth)        |
| 8x_NMKD-Faces_160000_G                | 8x_NMKD-Faces_160000_G.pth                | 67.2 MB | Pros: Exceptional facial feature enhancement; preserves skin tone and expression.<br/>Cons: Can desaturate; underperforms on full-scene upscales.<br/>Use When: Close-up portraits or any task focused purely on facial detail.                                                                | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/8x_NMKD-Faces_160000_G.pth)                |
| 8xNMKDSuperscale_150000G              | 8xNMKDSuperscale_150000G.pt               | 67.1 MB | Pros: Robust 8× upscale with strong structure retention.<br/>Cons: Very high VRAM use; slower throughput; may OOM on ≤6 GB cards.<br/>Use When: You need an 8× upscale and have ample GPU memory (≥10 GB).                                                                                     | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/8xNMKDSuperscale_150000G.pt)               |
| 4x_UniversalUpscalerV2-Sharp_101000_G | 4x_UniversalUpscalerV2-Sharp_101000_G.pth | 67 MB   | Pros: Universal sharpening across varied subjects; boosts edge clarity.<br/>Cons: Prone to haloing around edges; can introduce unnatural sharpening artifacts.<br/>Use When: You want extra edge pop on diverse content (architecture, text, renders).                                         | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/upscalers/4x_UniversalUpscalerV2-Sharp_101000_G.pth) |

## 🧠 SAM (Segment Anything Models)

| Model name | File name            | Size    | Details                              | Download                                                                                | Source                                                         |
|------------|----------------------|---------|--------------------------------------|-----------------------------------------------------------------------------------------|----------------------------------------------------------------|
| SAM ViT-L  | sam_vit_l_0b3195.pth | 51.6 MB | SAM ViT Large for segmentation tasks | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/sam/sam_vit_l_0b3195.pth) | [GitHub](https://github.com/facebookresearch/segment-anything) |

## 🟥 BBOX (Object Detection)

| Model name           | File name                   | Size    | Details                               | Download                                                                                        | Source                                                               |
|----------------------|-----------------------------|---------|---------------------------------------|-------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Face                 | face_yolov9c.pt             | 51.6 MB | Face detection   (YOLOv9c)            | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/face_yolov9c.pt)             | [HuggingFace](https://huggingface.co/Bingsu/adetailer)               |
| Eye                  | eyeful_individual_yolov8.pt | 22.5 MB | Eye/individual detection  (YOLOv8s)   | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/eyeful_individual_yolov8.pt) | [CivitAI](https://civitai.com/models/178518?modelVersionId=582139)   |
| Lips                 | lips-v1.pt                  | 6.22 MB | Lips detection                        | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/lips-v1.pt)                  | [CivitAI](https://civitai.com/models/138918?modelVersionId=157700)   |
| Hand                 | hand_yolov9c.pt             | 51.6 MB | Hand detection (YOLOv9c)              | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/hand_yolov9c.pt)             | [HuggingFace](https://huggingface.co/Bingsu/adetailer)               |
| Female Single Breast | female-single-breast.pt     | 36.6 MB | Singel breast (nipple) detection      | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/female-single-breast.pt)     | [CivitAI](https://civitai.com/models/135658?modelVersionId=149588)   |
| Female Breasts       | female-breasts-v4.7.pt      | 22.5 MB | Female breasts detection              | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/female-breasts-v4.7.pt)      | [CivitAI](https://civitai.com/models/138918?modelVersionId=688769)   |
| Buttocks             | buttocks.pt                 | 22.5 MB | Buttocks detection                    | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/buttocks.pt)                 | [CivitAI](https://civitai.com/models/1156687?modelVersionId=1300950) |
| Vagina               | vagina-v2.pt                | 6.21 MB | Vagina detection                      | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/vagina-v2.pt)                | [CivitAI](https://civitai.com/models/132388?modelVersionId=149617)   |
| Anus                 | anus-v3.pt                  | 22.5 MB | Anus detection                        | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/bbox/anus-v3.pt)                  | [CivitAI](https://civitai.com/models/132388?modelVersionId=334896)   |
| NudeNet              | nudenet-320n.pt             | 6.22 MB | NudeNet: lightweight Nudity detection | [Download](https://huggingface.co/SimonJoz/nudenet/resolve/main/320n.pt)                        | [GitHub](https://github.com/notAI-tech/NudeNet)                      |
| NudeNet              | nudenet-640m.pt             | 52 MB   | NudeNet: lightweight Nudity detection | [Download](https://huggingface.co/SimonJoz/nudenet/resolve/main/640m.pt)                        | [GitHub](https://github.com/notAI-tech/NudeNet)                      |

NudeNet Classes:

```pyton
 all_labels = [
    "FEMALE_GENITALIA_COVERED",
    "FACE_FEMALE",
    "BUTTOCKS_EXPOSED",
    "FEMALE_BREAST_EXPOSED",
    "FEMALE_GENITALIA_EXPOSED",
    "MALE_BREAST_EXPOSED",
    "ANUS_EXPOSED",
    "FEET_EXPOSED",
    "BELLY_COVERED",
    "FEET_COVERED",
    "ARMPITS_COVERED",
    "ARMPITS_EXPOSED",
    "FACE_MALE",
    "BELLY_EXPOSED",
    "MALE_GENITALIA_EXPOSED",
    "ANUS_COVERED",
    "FEMALE_BREAST_COVERED",
    "BUTTOCKS_COVERED",
]
```

## 🟪 SEGM (Segmentation)

| Model name        | File name                        | Size    | Details           | Download                                                                                             | Source                                                       |
|-------------------|----------------------------------|---------|-------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| BiSeNetV1 CelebHQ | face_bisenetv1_celebhq_79999.pth | 53.3 MB | Face segmentation | [Download](https://huggingface.co/SimonJoz/comfy/resolve/main/segm/face_bisenetv1_celebhq_79999.pth) | [GitHub](https://github.com/zllrunning/face-parsing.PyTorch) |

## Total Size: 0.74 GB

```shell
echo "scale=2; (6.22+52+67+9.02+9.02+67+67.2+67.1+67+51.6+51.6+51.6+22.5+53.3+6.22+36.6+22.5+22.5+6.21+22.5)/1024" | bc | xargs -I{} echo "Total: {} GB"
```
