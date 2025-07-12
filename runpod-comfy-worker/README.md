# RunPod Comfy Worker

![Docker Pulls](https://img.shields.io/docker/pulls/simonjoz/runpod-comfy-worker)
![Docker Stars](https://img.shields.io/docker/stars/simonjoz/runpod-comfy-worker)
![Docker Image Size](https://img.shields.io/docker/image-size/simonjoz/runpod-comfy-worker/0.1.0-cuda12.6.3-ubuntu24.04)
![Docker Image Version](https://img.shields.io/docker/v/simonjoz/runpod-comfy-worker)

This Docker image is built on top of
the [runpod-comfy-base](https://hub.docker.com/repository/docker/simonjoz/runpod-comfy-base/)
image and provides a ready-to-use ComfyUI environment optimized for [RunPod](https://www.runpod.io/)..

## Features

* Preinstalled ComfyUI (depends on image - base: 0.3.32)
* CUDA support (depends on image - base: 12.6.3)
* Memory optimization via tcmalloc
* Auto-starts ComfyUI, Jupyter Lab, and Filebrowser
* Installs a curated set of ComfyUI custom nodes
* Optional model downloads based on environment config
* Optional SSH access via public key injection

## Exposed Ports

| Container Port | Service        | Notes                                 |
|----------------|----------------|---------------------------------------|
| `3000`         | ComfyUI        | UI at `http://<host>:3000`            |
| `8888`         | Jupyter Lab    | Token = `JUPYTER_PASSWORD`            |
| `4040`         | Filebrowser    | Admin = `FB_USERNAME` / `FB_PASSWORD` |
| `22`           | SSH (optional) | Enabled if `PUBLIC_KEY` is provided   |

## Environment Variables

| Variable                | Description                                                                                | Default |
|-------------------------|--------------------------------------------------------------------------------------------|---------|
| `NETWORK_VOLUME`        | Path to volume disk storage for models  (e.g., `/workspace`)                               | `unset` |
| `PUBLIC_KEY`            | Injects SSH key for remote access                                                          | `unset` |
| `JUPYTER_PASSWORD`      | Required for Jupyter Lab access (used as login token)                                      | `unset` |
| `FB_USERNAME`           | Required Filebrowser admin username                                                        | `unset` |
| `FB_PASSWORD`           | Required Filebrowser admin password                                                        | `unset` |
| `CUSTOM_NODES_LIST`     | Comma separated list of Custom Nodes to install (e.g., `ComfyUI-GGUF@1.1.0,rgthree-comfy`) | `unset` |
| `DOWNLOAD_SDXL`         | If `true`, download SDXL models                                                            | `false` |
| `DOWNLOAD_FLUX`         | If `true`, download Flux.1 Dev models                                                      | `false` |
| `DOWNLOAD_FLUX_KONTEXT` | If `true`, download Flux.1 Dev Kontext models                                              | `false` |
| `DOWNLOAD_WAN`          | If `true`, download Wan 2.1 models                                                         | `false` |
| `DOWNLOAD_HUNYUAN_DIT`  | If `true`, download Hunyuan DiT models                                                     | `false` |


## Default Custom Nodes List

> Note: The `CUSTOM_NODES_LIST` environment variable overwrites the default list. 
> It is useful if only a subset of nodes is needed, or if you want to define your own custom nodes.
> Please note that the default list can take some time to install.

```
nodes=(
    "ComfyUI-GGUF@1.1.0"
    "ComfyUI-Crystools@1.22.1"
    "ComfyUI-JoyCaption@1.1.1"
    "ComfyUI-WanVideoWrapper@1.1.9"
    "comfyui_ultimatesdupscale@1.2.0"
    "comfyui-kjnodes@1.1.1"
    "rgthree-comfy@1.0.0"
    "comfyui-impact-pack@8.15.3"
    "comfyui-impact-subpack@1.3.2"
    "comfyui_controlnet_aux@1.0.7"
    "was-node-suite-comfyui@1.0.2"
    "comfyui_essentials@1.1.0"
    "comfyui-florence2@1.0.5"
    "comfyui_controlnet_aux@1.0.7"
    "comfyui_ipadapter_plus@2.0.0"
    "comfyui-image-saver@1.4.0"
    "comfyui-advancedliveportrait@1.0.0"
    "comfyui_pulid_flux_ll@1.1.4"
    "comfyui_faceanalysis@1.0.0"
    "comfyui-videohelpersuite@1.6.1"
    "comfyui-multigpu@1.7.3"
    "cg-use-everywhere@6.2.0"
    "comfyui-lama-remover@1.0.0"
    "comfyui-inspyrenet-rembg@1.1.1"
    "comfyui-detail-daemon@1.1.2"
    "teacache@1.6.1"
    "gguf@2.1.3"
    "x-flux-comfyui"
    "dreamo"
    "comfyui-easy-use@1.3.0"
    "efficiency-nodes-comfyui@1.0.7"
    "comfyui-custom-scripts@1.2.5"
  )
```

## Usage

Run the container with the required ports exposed. Volume mounts and environment variables are optional, depending on
your use case.

### Basic

```bash
docker pull simonjoz/runpod-comfy-worker:<tag>
docker run --gpus all -p 3000:3000 -p 8888:8888 -p 4040:4040 simonjoz/runpod-comfy-worker:<tag>
```

### Advanced

```bash
docker run --gpus all \
  -v /host/dir:/workspace \
  -e NETWORK_VOLUME=/workspace \
  -e PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  -e JUPYTER_PASSWORD=<pw> \
  -e FB_USERNAME=<user> \
  -e FB_PASSWORD=<pw> \
  -e DOWNLOAD_SDXL=true \
  -e DOWNLOAD_FLUX=true \
  -e DOWNLOAD_FLUX_KONTEXT=true \
  -e DOWNLOAD_WAN=true \
  -e DOWNLOAD_HUNYUAN_DIT=true \
  -p 3000:3000 \
  -p 8888:8888 \
  -p 4040:4040 \
  -p 22:22 \
  simonjoz/runpod-comfy-worker:<tag>
```

#### Docker Compose

```yaml
version: '3.8'

services:
  comfy-worker:
    image: simonjoz/runpod-comfy-worker:<tag>
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [ gpu ]
    volumes:
      - /host/dir:/workspace
    environment:
      NETWORK_VOLUME: /workspace
      PUBLIC_KEY: "${PUBLIC_KEY}"
      JUPYTER_PASSWORD: "${JUPYTER_PASSWORD}"
      FB_USERNAME: "${FB_USERNAME}"
      FB_PASSWORD: "${FB_PASSWORD}"
      DOWNLOAD_SDXL: "true"
      DOWNLOAD_FLUX: "true"
      DOWNLOAD_FLUX_KONTEXT: "true"
      DOWNLOAD_WAN: "true"
      DOWNLOAD_HUNYUAN_DIT: "true"
    ports:
      - "3000:3000"
      - "8888:8888"
      - "4040:4040"
      - "22:22"
```

## License

MIT
