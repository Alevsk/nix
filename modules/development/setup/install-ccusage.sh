#!/usr/bin/env bash
set -euo pipefail

# Check if bun is available
if ! command -v bun >/dev/null 2>&1; then
    echo "Bun not found. Skipping ccusage installation."
    exit 0
fi

# Install ccusage if not already available
if ! command -v ccusage >/dev/null 2>&1; then
    echo "Installing ccusage globally via bun..."
    if bun add --global ccusage; then
        echo "ccusage installed successfully!"
    else
        echo "Warning: ccusage installation failed" >&2
        exit 1
    fi
else
    echo "ccusage already installed, skipping..."
fi
