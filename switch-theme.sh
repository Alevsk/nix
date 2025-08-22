#!/usr/bin/env bash

# Terminal Theme Switcher for Nix Configuration
# Direct sed-based theme switching that modifies actual config files

ALACRITTY_CONFIG="$HOME/nix/modules/terminal/alacritty.nix"
ZSH_CONFIG="$HOME/nix/modules/shell/zsh.nix"

# Available themes
declare -A THEMES
THEMES[1]="catppuccin"
THEMES[2]="dracula"
THEMES[3]="cyberpunk" 
THEMES[4]="ocean"
THEMES[5]="tokyonight"
THEMES[6]="nord"

echo "🎨 Terminal Theme Switcher"
echo "========================="
echo ""
echo "Available themes:"
echo "1) Catppuccin - Clean dark theme with purple accents"
echo "2) Dracula - Popular purple theme"
echo "3) Cyberpunk - Neon green/pink colors"
echo "4) Ocean - Calm blue/teal palette"
echo "5) Tokyo Night - Dark theme with purple and blue"
echo "6) Nord - Arctic, north-bluish color palette"
echo ""

read -p "Select theme (1-6): " choice

if [[ -n "${THEMES[$choice]}" ]]; then
    selected_theme="${THEMES[$choice]}"
    
    echo "🔄 Switching to $selected_theme theme..."
    
    # Create backups
    cp "$ALACRITTY_CONFIG" "$ALACRITTY_CONFIG.bak"
    cp "$ZSH_CONFIG" "$ZSH_CONFIG.bak"
    
    # Apply theme-specific colors
    case $selected_theme in
        "catppuccin")
            # Catppuccin Mocha
            bg="#1e1e2e"; fg="#cdd6f4"; cursor="#f5e0dc"
            black="#45475a"; red="#f38ba8"; green="#a6e3a1"; yellow="#f9e2af"
            blue="#89b4fa"; magenta="#f5c2e7"; cyan="#94e2d5"; white="#bac2de"
            bright_black="#585b70"; bright_white="#a6adc8"
            p10k_dir_fg="31"; p10k_dir_bg="237"
            ;;
        "dracula")
            # Dracula
            bg="#282a36"; fg="#f8f8f2"; cursor="#f8f8f2"
            black="#000000"; red="#ff5555"; green="#50fa7b"; yellow="#f1fa8c"
            blue="#bd93f9"; magenta="#ff79c6"; cyan="#8be9fd"; white="#bfbfbf"
            bright_black="#4d4d4d"; bright_white="#e6e6e6"
            p10k_dir_fg="15"; p10k_dir_bg="61"
            ;;
        "tokyonight")
            # Tokyo Night
            bg="#1a1b26"; fg="#c0caf5"; cursor="#c0caf5"
            black="#15161e"; red="#f7768e"; green="#9ece6a"; yellow="#e0af68"
            blue="#7aa2f7"; magenta="#bb9af7"; cyan="#7dcfff"; white="#a9b1d6"
            bright_black="#414868"; bright_white="#c0caf5"
            p10k_dir_fg="15"; p10k_dir_bg="57"
            ;;
        "nord")
            # Nord
            bg="#2e3440"; fg="#d8dee9"; cursor="#d8dee9"
            black="#3b4252"; red="#bf616a"; green="#a3be8c"; yellow="#ebcb8b"
            blue="#81a1c1"; magenta="#b48ead"; cyan="#88c0d0"; white="#e5e9f0"
            bright_black="#4c566a"; bright_white="#eceff4"
            p10k_dir_fg="15"; p10k_dir_bg="67"
            ;;
    esac
    
    # Update Alacritty colors
    sed -i '' "s/background = \"#[^\"]*\"/background = \"$bg\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/foreground = \"#[^\"]*\"/foreground = \"$fg\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/cursor = \"#[^\"]*\"/cursor = \"$cursor\"/" "$ALACRITTY_CONFIG"
    
    # Update normal colors
    sed -i '' "s/black = \"#[^\"]*\"/black = \"$black\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/red = \"#[^\"]*\"/red = \"$red\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/green = \"#[^\"]*\"/green = \"$green\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/yellow = \"#[^\"]*\"/yellow = \"$yellow\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/blue = \"#[^\"]*\"/blue = \"$blue\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/magenta = \"#[^\"]*\"/magenta = \"$magenta\"/" "$ALACRITTY_CONFIG"
    sed -i '' "s/cyan = \"#[^\"]*\"/cyan = \"$cyan\"/" "$ALACRITTY_CONFIG"
    
    # Update p10k colors
    sed -i '' "s/POWERLEVEL9K_DIR_FOREGROUND=[0-9]*/POWERLEVEL9K_DIR_FOREGROUND=$p10k_dir_fg/" "$ZSH_CONFIG"
    sed -i '' "s/POWERLEVEL9K_DIR_BACKGROUND=[0-9]*/POWERLEVEL9K_DIR_BACKGROUND=$p10k_dir_bg/" "$ZSH_CONFIG"
    
    echo "🔧 Rebuilding configuration..."
    cd "$HOME/nix" && home-manager switch --flake ~/nix#alevsk
    
    if [ $? -eq 0 ]; then
        echo "✅ Theme switched to $selected_theme successfully!"
        echo "🔄 Restart your terminal to see all changes."
        echo "📄 Theme colors updated in alacritty.nix and zsh.nix"
        rm -f "$ALACRITTY_CONFIG.bak" "$ZSH_CONFIG.bak"
    else
        echo "❌ Failed to rebuild configuration. Restoring backups..."
        mv "$ALACRITTY_CONFIG.bak" "$ALACRITTY_CONFIG"
        mv "$ZSH_CONFIG.bak" "$ZSH_CONFIG"
    fi
else
    echo "❌ Invalid selection. Please choose 1-6."
fi
