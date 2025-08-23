# Alevsk's Nix Darwin Configuration

A declarative macOS system configuration using Nix Darwin and Home Manager with integrated theming.

## 📁 Project Structure

```
~/nix/
├── flake.nix                 # Main flake configuration
├── darwin-configuration.nix  # System-level configuration
├── home.nix                 # User-level configuration
├── modules/                 # Modular configurations
│   ├── cli/fzf.nix          # FZF fuzzy finder
│   ├── desktop/wallpaper.nix # Desktop wallpaper
│   ├── editor/neovim.nix    # Neovim configuration
│   ├── git/git.nix          # Git configuration
│   ├── multiplexer/tmux.nix # Tmux configuration
│   ├── shell/zsh.nix        # Zsh with Powerlevel10k
│   └── terminal/alacritty.nix # Alacritty terminal
└── switch-theme.sh          # Theme switching script
```

## 🚀 Quick Start

1. **Install Nix**:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Apply configuration**:
   ```bash
   cd ~/nix
   sudo darwin-rebuild switch --flake .#cloud
   home-manager switch --flake .#alevsk
   ```

3. **Daily usage**:
   ```bash
   # System changes
   sudo darwin-rebuild switch --flake ~/nix#cloud
   
   # User dotfiles changes  
   home-manager switch --flake ~/nix#alevsk
   ```

## 📦 Installed Software

### System Packages (Nix)
- **Development**: Git, Neovim, VSCode, Windsurf
- **Terminal**: Alacritty, Tmux
- **Communication**: Telegram Desktop
- **Fonts**: JetBrains Mono Nerd Font

### User Packages
- **CLI Tools**: bat, eza, fzf, ripgrep, fd, tree, htop
- **Development**: Node.js, Python3, Go
- **AI**: Ollama
- **Fonts**: FiraCode, DroidSansMono, MesloLGS Nerd Fonts

### GUI Applications (Homebrew)
- **Browsers**: Google Chrome, Firefox
- **Productivity**: 1Password, Rectangle
- **Media**: IINA
- **Development**: Hammerspoon, Sublime Text
- **Utilities**: The Unarchiver
- **CLI Tools**: mas, fastfetch, gemini-cli, codex

## 🎨 Theming System

### Quick Theme Change

Edit `home.nix` and modify:

```nix
currentThemeName = "nord";    # Available: nord, dracula, tokyonight, ocean, default
promptStyle = "lean";         # Available: lean, classic, rainbow
autoStartTmux = false;        # Auto-start tmux in new terminals
```

Then apply: `home-manager switch --flake ~/nix#alevsk`

### Available Themes
- **`nord`** - Cool blue/gray Nordic theme (default)
- **`dracula`** - Purple/pink theme
- **`tokyonight`** - Dark blue Tokyo Night theme
- **`ocean`** - Blue/teal ocean theme
- **`default`** - Catppuccin Mocha theme

### Prompt Styles
- **`lean`** - Minimal single-line prompt
- **`classic`** - Multi-line with decorative borders
- **`rainbow`** - Colorful with system information

### Theme Integration
- **Stylix**: Consistent theming across applications
- **nix-colors**: Base16 color schemes
- **Dynamic colors**: Prompt styles adapt to selected theme
- **Unified fonts**: MesloLGS Nerd Font across applications

## 🔧 Customization

### Adding Packages

**System packages**:
```nix
# darwin-configuration.nix
environment.systemPackages = with pkgs; [ new-package ];
```

**User packages**:
```nix
# home.nix
home.packages = with pkgs; [ new-package ];
```

**GUI applications**:
```nix
# darwin-configuration.nix
homebrew.casks = [ "new-app" ];
```

### Module Configuration

- **Zsh**: `modules/shell/zsh.nix`
- **Alacritty**: `modules/terminal/alacritty.nix`
- **Neovim**: `modules/editor/neovim.nix`
- **Git**: `modules/git/git.nix`
- **Tmux**: `modules/multiplexer/tmux.nix`
- **FZF**: `modules/cli/fzf.nix`
- **Wallpaper**: `modules/desktop/wallpaper.nix`

### Adding Custom Themes

1. Check [nix-colors schemes](https://github.com/Misterio77/nix-colors)
2. Add to `themeMap` in `home.nix`:
   ```nix
   themeMap = {
     "mytheme" = nix-colors.colorSchemes.my-theme-name;
   };
   ```

## 🔄 Maintenance

```bash
# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d

# Check syntax
nix flake check

# Show flake info
nix flake show

# Search packages
nix search nixpkgs package-name

# Rollback changes
sudo darwin-rebuild rollback        # System
home-manager rollback              # User
```

## 🐛 Troubleshooting

- **Permission errors**: Use `sudo` with `darwin-rebuild`
- **Flake not found**: Ensure you're in `~/nix` directory
- **Build failures**: Check `.nix` file syntax
- **Conflicts**: Remove existing dotfiles that conflict

## 📚 Resources

- [Package Search](https://search.nixos.org/)
- [Nix Darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Stylix](https://github.com/nix-community/stylix)
- [nix-colors](https://github.com/Misterio77/nix-colors)