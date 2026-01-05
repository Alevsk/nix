#!/usr/bin/env bash
set -euo pipefail

# Ensure homebrew bin is in PATH
export PATH="/opt/homebrew/bin:$PATH"

# Configuration
NPM_GLOBAL_DIR="$HOME/.npm-global"
MARKER_DIR="$HOME/.local/state/nix-npm"
PLAYWRIGHT_VERSION="1.55.1"
PLAYWRIGHT_BROWSERS_PATH="$HOME/.cache/ms-playwright"

# Packages to install globally (name:version or just name for latest)
GLOBAL_PACKAGES=(
    "pnpm"
    "playwright@$PLAYWRIGHT_VERSION"
)

mkdir -p "$MARKER_DIR"

# Check if node is available
if ! command -v node >/dev/null 2>&1; then
    echo "Node.js not found, skipping npm package installation"
    exit 0
fi

# Function to check if a package is installed at the expected version
is_package_installed() {
    local pkg="$1"
    local name="${pkg%%@*}"
    local version="${pkg#*@}"

    # If no version specified, just check if installed
    if [[ "$name" == "$version" ]]; then
        npm list -g "$name" --depth=0 &>/dev/null
        return $?
    fi

    # Check specific version
    local installed_version
    installed_version=$(npm list -g "$name" --depth=0 2>/dev/null | grep "$name@" | sed 's/.*@//' || echo "")
    [[ "$installed_version" == "$version" ]]
}

# Install global npm packages (only if not already installed)
packages_to_install=()
for pkg in "${GLOBAL_PACKAGES[@]}"; do
    if ! is_package_installed "$pkg"; then
        packages_to_install+=("$pkg")
    fi
done

if [[ ${#packages_to_install[@]} -gt 0 ]]; then
    echo "Installing global npm packages: ${packages_to_install[*]}"
    npm install -g "${packages_to_install[@]}" || true
else
    echo "Global npm packages already installed, skipping..."
fi

# Install Playwright browsers (only if not already installed or version changed)
PLAYWRIGHT_MARKER="$MARKER_DIR/playwright-browsers-$PLAYWRIGHT_VERSION"

install_playwright_browsers() {
    echo "Installing Playwright browsers (chromium)..."
    PLAYWRIGHT_BROWSERS_PATH="$PLAYWRIGHT_BROWSERS_PATH" \
    npx --yes "playwright@$PLAYWRIGHT_VERSION" install chromium || true
    touch "$PLAYWRIGHT_MARKER"
    echo "Playwright setup completed!"
}

if [[ ! -f "$PLAYWRIGHT_MARKER" ]]; then
    # Clean up old version markers
    rm -f "$MARKER_DIR"/playwright-browsers-* 2>/dev/null || true
    install_playwright_browsers
else
    # Verify browsers actually exist
    if [[ -d "$PLAYWRIGHT_BROWSERS_PATH" ]] && ls "$PLAYWRIGHT_BROWSERS_PATH"/chromium-* &>/dev/null; then
        echo "Playwright browsers already installed, skipping..."
    else
        install_playwright_browsers
    fi
fi
