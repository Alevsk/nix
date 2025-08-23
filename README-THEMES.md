# 🎨 Dynamic Theme and Prompt System

Your Nix configuration includes an integrated theme system with **Stylix** and **nix-colors** that automatically applies consistent colors across all applications.

## 🔄 Theme System

### Quick Theme Switching

Edit `home.nix` and change these two lines:

```nix
# Available: dracula, nord, tokyonight, ocean, default
currentThemeName = "nord";

# Available: lean, classic, rainbow  
promptStyle = "lean";
```

Then apply:
```bash
home-manager switch --flake ~/nix#alevsk
```

### Available Themes
- **`nord`** - Cool blue/gray Nordic theme (default)
- **`dracula`** - Popular purple/pink theme
- **`tokyonight`** - Dark blue Tokyo Night theme
- **`ocean`** - Blue/teal ocean theme
- **`default`** - Catppuccin Mocha theme

### Available Prompt Styles
- **`lean`** - Minimal single-line prompt
- **`classic`** - Multi-line with decorative borders  
- **`rainbow`** - Colorful with system information

## 🎨 Creating Custom Themes

To add a new theme:

1. **Check nix-colors**: See if your theme exists at [nix-colors schemes](https://github.com/Misterio77/nix-colors)
2. **Add to themeMap**: Edit `home.nix` and add your theme:
   ```nix
   themeMap = {
     # existing themes...
     "mytheme" = nix-colors.colorSchemes.my-theme-name;
   };
   ```
3. **Apply**: `home-manager switch --flake ~/nix#alevsk`

## 🎯 Creating Custom Prompt Styles

To add a new Powerlevel10k style:

1. **Edit zsh.nix**: Add your style to the `promptStyles` attribute set
2. **Use Stylix colors**: Reference colors with `config.lib.stylix.colors.base0X`
3. **Test**: Change `promptStyle` in `home.nix` and rebuild

Example custom style:
```nix
mystyle = ''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base05}'
  # ... more customization
'';
```

Happy theming! 🌈
