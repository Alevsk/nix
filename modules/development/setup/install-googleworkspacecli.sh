#!/usr/bin/env bash
set -euo pipefail

# Check if bun is available
if ! command -v bun >/dev/null 2>&1; then
    echo "Bun not found. Skipping @googleworkspace/cli installation."
    exit 0
fi

# Install @googleworkspace/cli if not already available
if ! command -v gws >/dev/null 2>&1; then
    echo "Installing @googleworkspace/cli globally via bun..."
    if bun add --global @googleworkspace/cli; then
        echo "@googleworkspace/cli installed successfully!"
    else
        echo "Warning: @googleworkspace/cli installation failed" >&2
        exit 1
    fi
else
    echo "@googleworkspace/cli already installed, skipping..."
fi
