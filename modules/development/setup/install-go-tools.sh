#!/usr/bin/env bash
set -euo pipefail

# Check if go is available
if ! command -v go >/dev/null 2>&1; then
    echo "Go not found. Skipping Go tools installation."
    exit 0
fi

export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOBIN:-$GOPATH/bin}"

# Create GOPATH directories if they don't exist
mkdir -p "$GOBIN"

# List of Go tools to install via `go install`
# Format: binary_name=module_path@version
GO_TOOLS=(
    "tukituki=github.com/dvaldivia/tukituki/cmd/tukituki@latest"
    "protoc-gen-grpc-gateway=github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.19.1"
    "protoc-gen-openapiv2=github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.19.1"
)

for tool_entry in "${GO_TOOLS[@]}"; do
    binary_name="${tool_entry%%=*}"
    module_path="${tool_entry#*=}"

    if [ ! -f "$GOBIN/$binary_name" ]; then
        echo "Installing $binary_name..."
        if go install "$module_path"; then
            echo "$binary_name installed successfully!"
        else
            echo "Warning: $binary_name installation failed" >&2
        fi
    else
        echo "$binary_name already installed, skipping..."
    fi
done
