#!/usr/bin/env bash
set -euo pipefail

# Ensure homebrew bin is in PATH
export PATH="/opt/homebrew/bin:$PATH"

# Check if node is available
if ! command -v node >/dev/null 2>&1; then
    echo "Node.js not found, skipping npm package installation"
    exit 0
fi

# Install Node.js packages globally
echo "Installing global npm packages..."
npm install -g pnpm playwright || true

# Install Playwright browsers with proper configuration
echo "Installing Playwright browsers..."
PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0 \
PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright" \
npx -y playwright@1.55.1 install chromium || true

echo "Playwright setup completed!"