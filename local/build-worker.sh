#!/bin/bash

set -euo

BUILDER_NAME="runpod-comfy-builder"

# Create builder if it doesn't exist
if ! docker buildx inspect "$BUILDER_NAME" &>/dev/null; then
  docker buildx create --name "$BUILDER_NAME" --use
  docker buildx inspect --bootstrap
else
  docker buildx use "$BUILDER_NAME"
fi

echo "Using builder: $BUILDER_NAME"
docker buildx bake worker
# docker buildx bake --set worker.platform=linux/arm64 worker --load
