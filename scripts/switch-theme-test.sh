#!/usr/bin/env bash
# Non-interactive theme switcher for testing
# Usage: switch-theme-test.sh <theme> <prompt_style> [engine]

set -euo pipefail

THEME="${1:-}"
PROMPT_STYLE="${2:-}"
ENGINE="${3:-powerlevel10k}"  # Default to powerlevel10k for backward compatibility
HOME_NIX_FILE="$HOME/nix/home.nix"

VALID_THEMES=("nord" "dracula" "tokyonight" "ocean" "catppuccin" "gruvbox" "gruvbox-light" "solarized-dark" "solarized-light" "onedark" "monokai" "rose-pine" "rose-pine-moon" "everforest" "kanagawa")
VALID_PROMPTS=("lean" "classic" "pure" "powerline" "developer" "unix" "minimal" "boxed" "capsule" "slanted" "starship" "hacker" "arrow" "soft" "rainbow")
VALID_ENGINES=("powerlevel10k" "starship")

# Validation
if [[ -z "$THEME" ]] || [[ -z "$PROMPT_STYLE" ]]; then
    echo "Usage: $0 <theme> <prompt_style> [engine]"
    echo "Themes: ${VALID_THEMES[*]}"
    echo "Prompts: ${VALID_PROMPTS[*]}"
    echo "Engines: ${VALID_ENGINES[*]} (default: powerlevel10k)"
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

# Validate engine
if [[ ! " ${VALID_ENGINES[*]} " =~ " ${ENGINE} " ]]; then
    echo "Error: Invalid engine '$ENGINE'. Valid: ${VALID_ENGINES[*]}"
    exit 1
fi

echo "Switching to theme=$THEME, prompt=$PROMPT_STYLE, engine=$ENGINE"

# Update home.nix
sed -i '' "s/currentThemeName = \"[^\"]*\"/currentThemeName = \"$THEME\"/" "$HOME_NIX_FILE"
sed -i '' "s/promptStyle = \"[^\"]*\"/promptStyle = \"$PROMPT_STYLE\"/" "$HOME_NIX_FILE"
sed -i '' "s/promptEngine = \"[^\"]*\"/promptEngine = \"$ENGINE\"/" "$HOME_NIX_FILE"

# Rebuild
echo "Running home-manager switch..."
if home-manager switch --flake ~/nix#alevsk 2>&1; then
    echo "SUCCESS: Theme switched to $THEME with $PROMPT_STYLE prompt ($ENGINE engine)"
else
    echo "FAILED: home-manager switch failed"
    exit 1
fi
