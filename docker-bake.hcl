variable "BASE_VERSION" {
  default = "0.1.0"
}

variable "WORKER_VERSION" {
  default = "0.1.0"
}

variable "DOCKER_USERNAME" {
  default = "simonjoz"
}

variable "DOCKER_BASE_REPO" {
  default = "runpod-comfy-base"
}

variable "DOCKER_WORKER_REPO" {
  default = "runpod-comfy-worker"
}

group "default" {
  targets = ["base", "worker"]
}

target "base" {
  context    = "./runpod-comfy-base"
  dockerfile = "Dockerfile"
  platforms  = ["linux/arm64"]
  output     = ["type=registry"]
  args       = { BASE_IMAGE = "nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04" }
  tags       = ["${DOCKER_USERNAME}/${DOCKER_BASE_REPO}:${BASE_VERSION}-cuda12.6.3-ubuntu24.04"]
}

target "worker" {
  context    = "./runpod-comfy-worker"
  dockerfile = "Dockerfile"
  platforms  = ["linux/arm64"]
  output     = ["type=registry"]
  args       = {
    CUDA_VERSION    = "12.6"
    COMFYUI_HOME    = "/ComfyUI"
    COMFYUI_VERSION = "0.3.32"
    BASE_IMAGE      = "${DOCKER_USERNAME}/${DOCKER_BASE_REPO}:${BASE_VERSION}-cuda12.6.3-ubuntu24.04"
  }
  tags = ["${DOCKER_USERNAME}/${DOCKER_WORKER_REPO}:${WORKER_VERSION}-cuda12.6.3-ubuntu24.04"]
}
