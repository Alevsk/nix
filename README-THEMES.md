# 🎨 Terminal Theme System

Your Nix configuration now includes a modular theme system with multiple beautiful themes for both Alacritty and Powerlevel10k.

## 📁 Theme Structure

```
modules/terminal/themes/
├── default.nix      # Clean minimal theme
├── cyberpunk.nix    # Neon cyberpunk colors
├── ocean.nix        # Blue/teal ocean theme
├── dracula.nix      # Popular purple theme
└── theme-switcher.nix # Theme management system
```

## 🔄 How to Switch Themes

### Method 1: Direct File Editing (Recommended)

1. **Edit Alacritty colors** in `modules/terminal/alacritty.nix`:
   ```nix
   colors = {
     primary = { background = "#282a36"; foreground = "#f8f8f2"; };
     # ... copy colors from any theme file
   };
   ```

2. **Edit p10k colors** in `modules/shell/zsh.nix`:
   ```bash
   typeset -g POWERLEVEL9K_DIR_FOREGROUND=15
   typeset -g POWERLEVEL9K_DIR_BACKGROUND=61
   # ... customize colors
   ```

3. **Rebuild**: `home-manager switch --flake ~/nix#alevsk`

### Method 2: Theme Files Reference

Copy color schemes from the theme files:

**Dracula Theme:**
- Background: `#282a36`
- Foreground: `#f8f8f2`
- Accent: Purple/Pink

**Cyberpunk Theme:**
- Background: `#0a0e27`
- Foreground: `#00ff41`
- Accent: Neon colors

**Ocean Theme:**
- Background: `#0f1419`
- Foreground: `#b3b1ad`
- Accent: Blues/Teals

## 🎯 Customization Tips

### Powerlevel10k Elements
```bash
# Left prompt
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)

# Right prompt  
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

# Add more elements: background_jobs, ram, load, battery
```

### Color Codes
- Use 0-255 for terminal colors
- Use hex codes for Alacritty
- Test colors: `for i in {0..255}; do echo -e "\e[38;5;${i}mColor $i\e[0m"; done`

### Separators
```bash
# Powerline style
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""

# Sharp style
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""

# Minimal
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
```

## 🚀 Quick Theme Switch Commands

Add these aliases to your zsh config for quick switching:

```bash
alias theme-dracula="sed -i 's/background = \"#[^\"]*\"/background = \"#282a36\"/' ~/nix/modules/terminal/alacritty.nix && home-manager switch --flake ~/nix#alevsk"
alias theme-cyber="sed -i 's/background = \"#[^\"]*\"/background = \"#0a0e27\"/' ~/nix/modules/terminal/alacritty.nix && home-manager switch --flake ~/nix#alevsk"
```

## 🎨 Creating Custom Themes

1. Copy an existing theme file
2. Modify colors to your preference
3. Test with `home-manager switch --flake ~/nix#alevsk`
4. Restart terminal to see changes

Happy theming! 🌈
