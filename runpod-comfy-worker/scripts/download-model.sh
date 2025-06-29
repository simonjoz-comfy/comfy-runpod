#!/usr/bin/env bash

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Setup
# -e: exit on error
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
set -e

# ────────────────────────────────────────────────────────────────────────────────────────────────────────
# Download models using aria2c
# ────────────────────────────────────────────────────────────────────────────────────────────────────────
download_model() {
    local url="$1"
    local full_path="$2"

    local destination_dir destination_file
    destination_dir=$(dirname "$full_path")
    destination_file=$(basename "$full_path")

    mkdir -p "$destination_dir"

    # Check if file already exists
    if [[ -f "$full_path" ]]; then
        echo "INFO: ✅ $destination_file already exists, skipping download."
        return 0
    fi

    # Clean up orphaned aria2 control files
    for control_file in "${full_path}.aria2" "${full_path}.__temp"; do
        if [[ -f "$control_file" ]]; then
            echo "INFO: 🗑️ Removing stale control file: $control_file"
            rm -f "$control_file"
        fi
    done

    echo "INFO: 📥 Downloading $destination_file to $destination_dir..."

    # aria2c options
    local aria2_opts=(
        -x 16                           # 16 connections (max out bandwidth)
        -s 16                           # 16 segments for large files
        -k 5M                           # 5MB chunks (better for large files)
        --continue=true                 # Essential for resume capability
        --max-tries=5                   # Retries
        --retry-wait=2                  # Retry wait - 5s (network might need recovery time)
        --min-split-size=100M           # Only split files > 100MB
        --max-overall-download-limit=0  # No speed limit
        --max-download-limit=0          # No per-connection speed limit
        --summary-interval=30           # Progress updates every 30s
        --console-log-level=warn        # Less detailed loging
        --download-result=full          # Show complete download summary
        --auto-file-renaming=false      # Don't auto-rename on conflicts
        --allow-overwrite=false         # Don't overwrite existing files
        -d "$destination_dir"
        -o "$destination_file"
    )

    # Background download
    aria2c "${aria2_opts[@]}" "$url" &
    local download_pid=$!

    echo "INFO: 🚀  Download started in background for $destination_file (PID: $download_pid)"
}
