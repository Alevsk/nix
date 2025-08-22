#!/usr/bin/env bash

# Theme switcher script for Nix home-manager configuration

THEMES_DIR="$HOME/nix/modules/terminal/themes"
THEME_MANAGER="$HOME/nix/modules/terminal/theme-manager.nix"

# Available themes
declare -A THEMES
THEMES[1]="default"
THEMES[2]="cyberpunk" 
THEMES[3]="ocean"
THEMES[4]="dracula"

echo "🎨 Terminal Theme Switcher"
echo "========================="
echo ""
echo "Available themes:"
echo "1) Default - Clean and minimal theme"
echo "2) Cyberpunk - Neon cyberpunk theme with bright colors"
echo "3) Ocean - Calm ocean blues and teals"
echo "4) Dracula - Popular dark theme with purple accents"
echo ""

read -p "Select theme (1-4): " choice

if [[ -n "${THEMES[$choice]}" ]]; then
    selected_theme="${THEMES[$choice]}"
    echo "Switching to $selected_theme theme..."
    
    # Update theme-manager.nix
    sed -i.bak "s/selectedTheme = \".*\";/selectedTheme = \"$selected_theme\";/" "$THEME_MANAGER"
    
    echo "Rebuilding home-manager configuration..."
    cd "$HOME/nix" && home-manager switch --flake ~/nix#alevsk
    
    if [ $? -eq 0 ]; then
        echo "✅ Theme switched to $selected_theme successfully!"
        echo "🔄 Please restart your terminal to see the changes."
    else
        echo "❌ Failed to switch theme. Restoring backup..."
        mv "$THEME_MANAGER.bak" "$THEME_MANAGER"
    fi
else
    echo "❌ Invalid selection. Please choose 1-4."
fi
