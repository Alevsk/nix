#!/usr/bin/env bash
set -euo pipefail

# Check if bun is available
if ! command -v bun >/dev/null 2>&1; then
    echo "Bun not found. Skipping global npm tools installation."
    exit 0
fi

# List of global npm packages to install via `bun add --global`
# Format: binary_name=package_name
NPM_TOOLS=(
    "ccusage=ccusage"
    "gws=@googleworkspace/cli"
    "uipro=uipro-cli"
)

for tool_entry in "${NPM_TOOLS[@]}"; do
    binary_name="${tool_entry%%=*}"
    package_name="${tool_entry#*=}"

    if ! command -v "$binary_name" >/dev/null 2>&1; then
        echo "Installing $package_name globally via bun..."
        if bun add --global "$package_name"; then
            echo "$package_name installed successfully!"
        else
            echo "Warning: $package_name installation failed" >&2
        fi
    else
        echo "$binary_name already installed, skipping..."
    fi
done
