#!/usr/bin/env bash
set -euo pipefail

# Configuration (NIX_STATE_HOME is set by home-manager activation)
MARKER_DIR="${NIX_STATE_HOME:-$HOME/.local/state}/nix-npm"
PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright"

mkdir -p "$MARKER_DIR"

# Check if playwright is available (from Nix)
if ! command -v playwright >/dev/null 2>&1; then
    echo "Playwright not found in PATH. Skipping browser installation."
    exit 0
fi

# Get installed playwright version
PLAYWRIGHT_VERSION=$(playwright --version | awk '{print $2}')
PLAYWRIGHT_MARKER="$MARKER_DIR/playwright-browsers-$PLAYWRIGHT_VERSION"

install_playwright_browsers() {
    echo "Installing Playwright browsers (chromium) for version $PLAYWRIGHT_VERSION..."
    export PLAYWRIGHT_BROWSERS_PATH
    if playwright install chromium; then
        touch "$PLAYWRIGHT_MARKER"
        echo "Playwright setup completed!"
    else
        echo "Warning: Playwright browser installation failed" >&2
        return 1
    fi
}

if [[ ! -f "$PLAYWRIGHT_MARKER" ]]; then
    # Clean up old version markers
    rm -f "$MARKER_DIR"/playwright-browsers-* 2>/dev/null || true
    install_playwright_browsers
else
    # Verify browsers actually exist
    if [[ -d "$PLAYWRIGHT_BROWSERS_PATH" ]] && ls "$PLAYWRIGHT_BROWSERS_PATH"/chromium-* &>/dev/null; then
        echo "Playwright browsers already installed for version $PLAYWRIGHT_VERSION, skipping..."
    else
        install_playwright_browsers
    fi
fi
