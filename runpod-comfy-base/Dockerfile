# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Base RunPod Image
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
ARG BASE_IMAGE="nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04"

FROM $BASE_IMAGE

# Use bash with pipefail so pipeline errors cause the RUN step to fail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Set environment variables
# ────────────────────────────────────────────────────────────────────────────────────────────────────────

# Default shell
ENV SHELL=/bin/bash

# Locale variables to ensure UTF-8 encoding and consistent language environment
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Prevent pip from asking for confirmation during uninstall steps in custom nodes
ENV PIP_NO_INPUT=1

# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive

# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1

# Speed up some cmake builds
ENV CMAKE_BUILD_PARALLEL_LEVEL=8

# Override the default huggingface cache directory.
ENV HF_HOME="/runpod-volume/.cache/huggingface/"
ENV HF_DATASETS_CACHE="/runpod-volume/.cache/huggingface/datasets/"
ENV DEFAULT_HF_METRICS_CACHE="/runpod-volume/.cache/huggingface/metrics/"
ENV DEFAULT_HF_MODULES_CACHE="/runpod-volume/.cache/huggingface/modules/"
ENV HUGGINGFACE_HUB_CACHE="/runpod-volume/.cache/huggingface/hub/"
ENV HUGGINGFACE_ASSETS_CACHE="/runpod-volume/.cache/huggingface/assets/"

# Enable faster transfer of models from the hub to the container
ENV HF_HUB_ENABLE_HF_TRANSFER="1"

# Shared python package cache
ENV PIP_CACHE_DIR="/runpod-volume/.cache/pip/"
ENV VIRTUALENV_OVERRIDE_APP_DATA="/runpod-volume/.cache/virtualenv/"

# Overwrites PATH to prioritize the virtualenv at /opt/venv/bin - all python commands run in isolated venv
ENV PATH="/opt/venv/bin:$PATH"

# Enables cuDNN v8 API for faster convolution operations. Works on all modern NVIDIA GPUs
ENV TORCH_CUDNN_V8_API_ENABLED=1

# LAZY: Load CUDA modules on-demand (faster startup - recommended and beneficial for ComfyUI workflows)
# EAGER: Load all modules at startup (slower startup, slightly faster runtime)
ENV CUDA_MODULE_LOADING=LAZY

# Prevents Python from creating .pyc bytecode files, reducing disk I/O and storage usage
ENV PYTHONDONTWRITEBYTECODE=1


# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Install Packages
#
# System Utilities:
#
# - aria2                                : High-speed download utility supporting multiple protocols
# - sudo                                 : Allows running commands with elevated privileges
# - bash                                 : Default shell for running scripts and commands
# - vim                                  : Text editor for editing files inside the container
# - lsof                                 : Lists open files (useful for debugging resource issues)
# - locales                              : Provides locale data (language and region settings)
# - procps                               : Utilities to monitor system processes (e.g., ps, top)
# - unzip, zip                           : For handling compressed archive files
# - curl, wget                           : Command-line tools for downloading files over HTTP/FTP
# - file                                 : Determines file type and information
# - git                                  : Version control system for code management
# - inotify-tools                        : Tools to monitor file system events (used in watchers)
# - jq                                   : Lightweight JSON processor (parsing/manipulating JSON)
#
# Graphics & Multimedia Libraries:
#
# - libgl1                               : OpenGL library needed for graphical applications
# - ffmpeg                               : Multimedia framework to record, convert, and stream audio/video
# - libavcodec-dev, libavfilter-dev,
#   libavformat-dev, libavutil-dev,
#   libpostproc-dev, libswresample-dev,
#   libswscale-dev                       : FFmpeg-related dev libraries for audio/video processing
# - libjpeg-dev, libpng-dev, libtiff-dev : Image format libraries for JPEG, PNG, TIFF
# - libv4l-dev                           : Video capture library (for webcams, cameras)
# - libx264-dev                          : H.264 video encoder library
# - libxext6, libxrender-dev             : X11 extensions for rendering graphics
# - libxvidcore-dev                      : Video codec library for Xvid format
# - libsm6                               : X Session Management library for GUI apps
#
# Development Tools and Libraries:
#
# - build-essential                      : Compiler and essential build tools (gcc, make)
# - cmake                                : Build system generator, commonly used for C++ projects
# - libffi-dev                           : Foreign Function Interface library used by many Python packages for C bindings
# - libhdf5-serial-dev                   : Hierarchical Data Format library, used for storing large data arrays
# - libssl-dev                           : SSL/TLS cryptography library for secure connections
#
# Network and Storage:
#
# - openssh-server                       : SSH server for remote access if needed
# - ca-certificates                      : Trusted SSL certificates bundle
# - software-properties-common           : Utilities for managing software repositories
# - nfs-common                           : Tools to mount NFS network shares
# - zstd                                 : High-performance compression tool
#
# Python Environment:
#
# - python3.11                           : Python 3.11 interpreter
# - python3.11-dev                       : Python development headers (needed to build native extensions)
# - python3.11-venv                      : Virtual environment support for Python 3.11
# - python3.11-distutils                 : Tools for building and installing Python modules
# - python3-pip                          : Python package installer (pip)

# Memory Optimization:
#
# - libtcmalloc-minimal4  : Provides the runtime library for Google's high-performance memory allocator (tcmalloc),
#                          which helps reduce memory fragmentation and improve performance in memory-intensive
#                          applications like PyTorch and ComfyUI. Includes libtcmalloc.so but not development headers.
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
RUN set -eux && \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # System libraries
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    openssh-server ca-certificates  \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Storage
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    nfs-common zstd \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Build tools
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    build-essential cmake \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Essential tools
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    aria2 sudo bash vim lsof locales procps unzip zip curl wget file git inotify-tools jq \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Memory management (CRITICAL FOR PERFORMANCE)
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    libtcmalloc-minimal4 \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Graphics and media
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    libgl1 ffmpeg libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev \
    libjpeg-dev libpng-dev libpostproc-dev libswresample-dev libswscale-dev libtiff-dev \
    libv4l-dev libx264-dev libxext6 libxrender-dev libxvidcore-dev \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Python and development
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    libffi-dev libhdf5-serial-dev libsm6 libssl-dev \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Python
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    python3.11 python3.11-dev python3.11-venv && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Cleanup
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Locale setup
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Python setup
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    ln -sf /usr/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python /tmp/get-pip.py && rm /tmp/get-pip.py && \
    python -m pip install --upgrade --no-cache-dir pip virtualenv && \
    ln -sf /usr/local/bin/pip3.11 /usr/local/bin/pip && \
    python -m venv /opt/venv && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Install Jupiter
    #
    # - jupyterlab, notebook                 : Interactive computing environment
    # - ipywidgets                           : Interactive widgets for Jupyter notebooks
    # - jupyter-archive                      : Archive notebooks and data easily
    # - jupyter_contrib_nbextensions         : Collection of useful notebook extensions
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    python -m pip install --upgrade --no-cache-dir \
    jupyterlab \
    ipywidgets \
    jupyter-archive \
    jupyter_contrib_nbextensions \
    notebook==6.5.5 && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Install Filebrowser
    #
    # - filebrowser: Lightweight web-based file manager for easy container file access
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    curl -sSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Install Comfy CLI
    #
    # - Comfy CLI: Command-line interface for running and managing ComfyUI workflows
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    python -m pip install --upgrade --no-cache-dir comfy-cli && \
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    # Final cleanup:
    # - Strip out distribution docs
    # - Delete package test directories and embedded __pycache__ in the venv
    # ─────────────────────────────────────────────────────────────────────────────────────────────
    rm -rf /usr/share/doc /opt/venv/lib/python3.11/site-packages/*/tests && \
    find /opt/venv -type d -name '__pycache__' -exec rm -r {} +

CMD ["/bin/bash"]
