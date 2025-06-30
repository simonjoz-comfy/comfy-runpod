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
        -x 16                           # 16 connections per server (max bandwidth)
        -s 16                           # 16 segments per file (better for large files)
        -k 5M                           # 5MB chunk size
        --continue=true                 # Resume partial downloads
        --max-tries=5                   # Retry up to 5 times
        --retry-wait=2                  # Wait 2 seconds between retries
        --min-split-size=25M            # Split files only if >25MB
        --max-overall-download-limit=0  # No overall speed limit
        --max-download-limit=0          # No per-connection speed limit
        --console-log-level=warn        # Show warnings/errors only
        --download-result=full          # Show full download summary
        --auto-file-renaming=false      # Don’t rename files on conflict
        --allow-overwrite=true          # Overwrite existing files (set false to avoid)
        --check-certificate=true        # Verify SSL certificates
        --enable-http-keep-alive=true   # Keep HTTP connections alive
        --enable-http-pipelining=true   # Enable HTTP pipelining
        --header="Accept: */*"          # Accept all content types
        -d "$destination_dir"           # Download directory
        -o "$destination_file"          # Output filename
    )

    # Background download
    aria2c "${aria2_opts[@]}" "$url" &
    local download_pid=$!

    echo "INFO: 🚀  Download started in background for $destination_file (PID: $download_pid)"
}
