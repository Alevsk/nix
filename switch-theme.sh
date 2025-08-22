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
    
    # Create backup
    cp "$ALACRITTY_CONFIG" "$ALACRITTY_CONFIG.bak"
    cp "$ZSH_CONFIG" "$ZSH_CONFIG.bak"
    
    # Apply complete color scheme based on theme
    case $selected_theme in
        "default")
            # Catppuccin Mocha
            cat > /tmp/alacritty_colors.txt << 'EOF'
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
EOF
            p10k_dir_fg="31"; p10k_dir_bg="237"
            ;;
        "dracula")
            # Dracula theme
            cat > /tmp/alacritty_colors.txt << 'EOF'
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
        cursor = {
          text = "#282a36";
          cursor = "#f8f8f2";
        };
        normal = {
          black = "#000000";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#bd93f9";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#bfbfbf";
        };
        bright = {
          black = "#4d4d4d";
          red = "#ff6e67";
          green = "#5af78e";
          yellow = "#f4f99d";
          blue = "#caa9fa";
          magenta = "#ff92d0";
          cyan = "#9aedfe";
          white = "#e6e6e6";
        };
EOF
            p10k_dir_fg="15"; p10k_dir_bg="61"
            ;;
        "cyberpunk")
            # Cyberpunk theme
            cat > /tmp/alacritty_colors.txt << 'EOF'
        primary = {
          background = "#0a0e27";
          foreground = "#00ff41";
        };
        cursor = {
          text = "#0a0e27";
          cursor = "#ff0080";
        };
        normal = {
          black = "#000000";
          red = "#ff0040";
          green = "#00ff41";
          yellow = "#ffff00";
          blue = "#0080ff";
          magenta = "#ff0080";
          cyan = "#00ffff";
          white = "#ffffff";
        };
        bright = {
          black = "#808080";
          red = "#ff4080";
          green = "#40ff80";
          yellow = "#ffff80";
          blue = "#4080ff";
          magenta = "#ff40c0";
          cyan = "#40ffff";
          white = "#ffffff";
        };
EOF
            p10k_dir_fg="0"; p10k_dir_bg="13"
            ;;
        "ocean")
            # Ocean theme
            cat > /tmp/alacritty_colors.txt << 'EOF'
        primary = {
          background = "#0f1419";
          foreground = "#b3b1ad";
        };
        cursor = {
          text = "#0f1419";
          cursor = "#ffcc66";
        };
        normal = {
          black = "#01060e";
          red = "#ea6c73";
          green = "#91b362";
          yellow = "#f9af4f";
          blue = "#53bdfa";
          magenta = "#fae994";
          cyan = "#90e1c6";
          white = "#c7c7c7";
        };
        bright = {
          black = "#686868";
          red = "#f07178";
          green = "#c2d94c";
          yellow = "#ffb454";
          blue = "#59c2ff";
          magenta = "#ffee99";
          cyan = "#95e6cb";
          white = "#ffffff";
        };
EOF
            p10k_dir_fg="15"; p10k_dir_bg="24"
            ;;
    esac
    
    # Replace the entire colors section in Alacritty config
    sed -i '' '/# .*color scheme/,/};$/c\
      # '"$selected_theme"' color scheme\
      colors = {\
'"$(cat /tmp/alacritty_colors.txt)"'\
      };' "$ALACRITTY_CONFIG"
    
    # Update p10k colors
    sed -i '' "s/POWERLEVEL9K_DIR_FOREGROUND=[0-9]*/POWERLEVEL9K_DIR_FOREGROUND=$p10k_dir_fg/" "$ZSH_CONFIG"
    sed -i '' "s/POWERLEVEL9K_DIR_BACKGROUND=[0-9]*/POWERLEVEL9K_DIR_BACKGROUND=$p10k_dir_bg/" "$ZSH_CONFIG"
    
    # Clean up temp file
    rm -f /tmp/alacritty_colors.txt
    
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
