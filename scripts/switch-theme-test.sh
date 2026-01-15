#!/usr/bin/env bash
# Non-interactive theme switcher for testing
# Usage: switch-theme-test.sh <theme> <prompt_style>

set -euo pipefail

THEME="${1:-}"
PROMPT_STYLE="${2:-}"
HOME_NIX_FILE="$HOME/nix/home.nix"

VALID_THEMES=("nord" "dracula" "tokyonight" "ocean" "catppuccin" "gruvbox" "gruvbox-light" "solarized-dark" "solarized-light" "onedark" "monokai" "rose-pine" "rose-pine-moon" "everforest" "kanagawa")
VALID_PROMPTS=("lean" "classic" "pure" "powerline" "developer" "unix" "minimal" "boxed" "capsule" "slanted" "starship" "hacker" "arrow" "soft" "rainbow")

# Validation
if [[ -z "$THEME" ]] || [[ -z "$PROMPT_STYLE" ]]; then
    echo "Usage: $0 <theme> <prompt_style>"
    echo "Themes: ${VALID_THEMES[*]}"
    echo "Prompts: ${VALID_PROMPTS[*]}"
    exit 1
fi

# Validate theme
if [[ ! " ${VALID_THEMES[*]} " =~ " ${THEME} " ]]; then
    echo "Error: Invalid theme '$THEME'. Valid: ${VALID_THEMES[*]}"
    exit 1
fi

# Validate prompt
if [[ ! " ${VALID_PROMPTS[*]} " =~ " ${PROMPT_STYLE} " ]]; then
    echo "Error: Invalid prompt '$PROMPT_STYLE'. Valid: ${VALID_PROMPTS[*]}"
    exit 1
fi

echo "Switching to theme=$THEME, prompt=$PROMPT_STYLE"

# Update home.nix
sed -i '' "s/currentThemeName = \"[^\"]*\"/currentThemeName = \"$THEME\"/" "$HOME_NIX_FILE"
sed -i '' "s/promptStyle = \"[^\"]*\"/promptStyle = \"$PROMPT_STYLE\"/" "$HOME_NIX_FILE"

# Rebuild
echo "Running home-manager switch..."
if home-manager switch --flake ~/nix#alevsk 2>&1; then
    echo "SUCCESS: Theme switched to $THEME with $PROMPT_STYLE prompt"
else
    echo "FAILED: home-manager switch failed"
    exit 1
fi
