#!/usr/bin/env bash
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. Skipping uv tools installation."
    exit 0
fi

UV_TOOL_BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
mkdir -p "$UV_TOOL_BIN_DIR"

UV_TOOLS=(
    "graphify=graphifyy"
)

for tool_entry in "${UV_TOOLS[@]}"; do
    binary_name="${tool_entry%%=*}"
    package_name="${tool_entry#*=}"

    if ! command -v "$binary_name" >/dev/null 2>&1; then
        echo "Installing $package_name globally via uv..."
        if uv tool install "$package_name"; then
            echo "$package_name installed successfully!"
        else
            echo "Warning: $package_name installation failed" >&2
        fi
    else
        echo "$binary_name already installed, skipping..."
    fi
done

if command -v graphify >/dev/null 2>&1 && [ ! -f "$HOME/.cache/graphify-initialized" ]; then
    echo "Running graphify install..."
    if graphify install; then
        touch "$HOME/.cache/graphify-initialized"
        echo "graphify install completed successfully!"
    else
        echo "Warning: graphify install failed" >&2
    fi
fi
