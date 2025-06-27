# RunPod Comfy Base

![Docker Pulls](https://img.shields.io/docker/pulls/simonjoz/runpod-comfy-base)
![Docker Stars](https://img.shields.io/docker/stars/simonjoz/runpod-comfy-base)
![Docker Image Size](https://img.shields.io/docker/image-size/simonjoz/runpod-comfy-base/0.1.0-cuda12.6.3-ubuntu24.04)
![Docker Image Version](https://img.shields.io/docker/v/simonjoz/runpod-comfy-base)

**GPU-ready base image for RunPod AI workflows — optimized for performance, extensibility, and compatibility.**


## Overview

This repository provides a maintained Docker base image built on NVIDIA CUDA and cuDNN with Ubuntu, Python, and key
system libraries preinstalled. It’s designed for rapid setup of AI, ML, and ComfyUI-based workflows in containerized
environments like [RunPod](https://www.runpod.io/).

## Usage

```bash
docker pull simonjoz/runpod-comfy-base:0.1.0-cuda12.6.3-ubuntu24.04
docker run --gpus all -it simonjoz/runpod-comfy-base
````

## Core Features

- **CUDA 12.6 + cuDNN**, based on `nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04`
- **Python 3.11** with pip and virtualenv preconfigured in `/opt/venv`
- **JupyterLab** + notebook extensions and interactive widgets
- **Comfy CLI** preinstalled for ComfyUI workflow control
- **Filebrowser** for web-based container file access
- **Memory and I/O optimized** (e.g., `libtcmalloc`, no `.pyc`, pip/huggingface cache tuning)
- **Preinstalled media libraries** (FFmpeg, libx264, OpenGL, etc.)
- **Locale, environment, and cache configurations** for seamless AI development


## Environment Highlights

* Locale: `en_US.UTF-8`
* Python path: `/opt/venv/bin`
* CUDA settings: `CUDA_MODULE_LOADING=LAZY`, `TORCH_CUDNN_V8_API_ENABLED=1`
* HuggingFace, pip, virtualenv, and model cache locations optimized under `/runpod-volume/.cache`


## Memory Optimization Tip

To enable tcmalloc for better memory performance, run your container with:

```bash
export LD_PRELOAD=$(ldconfig -p | grep libtcmalloc_minimal.so | head -n1 | awk '{print $NF}')
```


## License

MIT
