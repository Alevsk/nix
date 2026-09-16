#!/usr/bin/env bash
set -euo pipefail

REPO="px0-ai/px0"
INSTALL_DIR="${HOME}/.local/bin"

# Detect OS and architecture (matches upstream release naming)
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)  ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

mkdir -p "$INSTALL_DIR"

TARGET_BIN="${INSTALL_DIR}/px0"

# Resolve latest version from GitHub API
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null \
  | grep '"tag_name":' | head -n 1 | sed -E 's/.*"tag_name": *"v?([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Warning: Could not determine latest px0 version (rate-limited?). Skipping." >&2
    exit 0
fi

# Check if already installed at this version
if [ -x "$TARGET_BIN" ]; then
    CURRENT_VER=$("$TARGET_BIN" -version 2>&1 | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?" | head -n 1 || true)
    if [ -z "$CURRENT_VER" ]; then
        CURRENT_VER=$("$TARGET_BIN" --version 2>&1 | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?" | head -n 1 || true)
    fi
    if [ "$CURRENT_VER" = "$LATEST_VERSION" ]; then
        echo "px0 v${CURRENT_VER} already installed, skipping..."
        exit 0
    fi
    echo "Updating px0 v${CURRENT_VER} -> v${LATEST_VERSION}..."
else
    echo "Installing px0 v${LATEST_VERSION}..."
fi

BINARY_NAME="px0-${LATEST_VERSION}-${OS}-${ARCH}"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${LATEST_VERSION}/${BINARY_NAME}"
FALLBACK_URL="https://github.com/${REPO}/releases/download/${LATEST_VERSION}/${BINARY_NAME}"

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

if ! curl -fsSL -o "$TMP_FILE" "$DOWNLOAD_URL" 2>/dev/null; then
    if ! curl -fsSL -o "$TMP_FILE" "$FALLBACK_URL" 2>/dev/null; then
        echo "Warning: Failed to download px0 from ${DOWNLOAD_URL}" >&2
        exit 0
    fi
fi

chmod +x "$TMP_FILE"
mv "$TMP_FILE" "$TARGET_BIN"
echo "px0 v${LATEST_VERSION} installed successfully!"
