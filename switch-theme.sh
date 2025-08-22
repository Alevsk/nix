#!/usr/bin/env bash

# Terminal Theme Switcher for Nix Configuration
# Applies colors from individual theme files to your active configuration

THEMES_DIR="$HOME/nix/modules/terminal/themes"
ALACRITTY_CONFIG="$HOME/nix/modules/terminal/alacritty.nix"
ZSH_CONFIG="$HOME/nix/modules/shell/zsh.nix"

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
echo "1) Default - Clean Catppuccin theme"
echo "2) Cyberpunk - Neon green/pink colors"
echo "3) Ocean - Calm blue/teal palette"
echo "4) Dracula - Popular purple theme"
echo ""

read -p "Select theme (1-4): " choice

if [[ -n "${THEMES[$choice]}" ]]; then
    selected_theme="${THEMES[$choice]}"
    theme_file="$THEMES_DIR/${selected_theme}.nix"
    
    if [[ ! -f "$theme_file" ]]; then
        echo "❌ Theme file not found: $theme_file"
        exit 1
    fi
    
    echo "🔄 Applying $selected_theme theme..."
    
    # Extract colors from theme file and apply to Alacritty config
    case $selected_theme in
        "default")
            bg="#1e1e2e"; fg="#cdd6f4"
            p10k_dir_fg="31"; p10k_dir_bg="237"
            ;;
        "dracula")
            bg="#282a36"; fg="#f8f8f2"
            p10k_dir_fg="15"; p10k_dir_bg="61"
            ;;
        "cyberpunk")
            bg="#0a0e27"; fg="#00ff41"
            p10k_dir_fg="0"; p10k_dir_bg="13"
            ;;
        "ocean")
            bg="#0f1419"; fg="#b3b1ad"
            p10k_dir_fg="15"; p10k_dir_bg="24"
            ;;
    esac
    
    # Update Alacritty background color
    sed -i.bak "s/background = \"#[^\"]*\"/background = \"$bg\"/" "$ALACRITTY_CONFIG"
    sed -i "s/foreground = \"#[^\"]*\"/foreground = \"$fg\"/" "$ALACRITTY_CONFIG"
    
    # Update p10k colors
    sed -i.bak "s/POWERLEVEL9K_DIR_FOREGROUND=[0-9]*/POWERLEVEL9K_DIR_FOREGROUND=$p10k_dir_fg/" "$ZSH_CONFIG"
    sed -i "s/POWERLEVEL9K_DIR_BACKGROUND=[0-9]*/POWERLEVEL9K_DIR_BACKGROUND=$p10k_dir_bg/" "$ZSH_CONFIG"
    
    echo "🔧 Rebuilding configuration..."
    cd "$HOME/nix" && home-manager switch --flake ~/nix#alevsk
    
    if [ $? -eq 0 ]; then
        echo "✅ Theme switched to $selected_theme successfully!"
        echo "🔄 Restart your terminal to see all changes."
        echo "📄 Full color schemes available in: $theme_file"
    else
        echo "❌ Failed to switch theme. Restoring backups..."
        [[ -f "$ALACRITTY_CONFIG.bak" ]] && mv "$ALACRITTY_CONFIG.bak" "$ALACRITTY_CONFIG"
        [[ -f "$ZSH_CONFIG.bak" ]] && mv "$ZSH_CONFIG.bak" "$ZSH_CONFIG"
    fi
else
    echo "❌ Invalid selection. Please choose 1-4."
fi
