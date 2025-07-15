## 🧱 [RunPod](https://runpod.io?ref=zlo74whj) Comfy Containers

----

This repository contains Docker build configurations for
deploying [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - based workflows using RunPod.

## 📦 Containers

---

### 1. RunPod Comfy Base

Base image with CUDA, cuDNN, and system dependencies installed. 
Used as a foundation for other ComfyUI containers.

[Docker Repository](https://hub.docker.com/repository/docker/simonjoz/runpod-comfy-base).


### 2. RunPod Comfy Worker

Worker image with a full [ComfyUI](https://github.com/comfyanonymous/ComfyUI) setup, including:
* A curated list of custom nodes
* Automatic model downloads
* Built-in extensions
* Predefined workflows for easy deployment

[Docker Repository](https://hub.docker.com/repository/docker/simonjoz/runpod-comfy-worker/general)
