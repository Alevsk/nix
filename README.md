# Alevsk's Nix Darwin Configuration

A declarative macOS system configuration using Nix Darwin and Home Manager.

## 📁 Project Structure

```
~/nix/
├── flake.nix                 # Main flake configuration with inputs
├── flake.lock               # Lock file for reproducible builds
├── darwin-configuration.nix  # System-level configuration (apps, settings, homebrew)
├── home.nix                 # User-level configuration (dotfiles, shell, programs)
└── README.md               # This file
```

## 🚀 Quick Start

### Initial Setup

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone and apply configuration**:
   ```bash
   git clone <your-repo> ~/nix
   cd ~/nix
   sudo darwin-rebuild switch --flake .#cloud
   ```

### Daily Usage

- **Apply configuration changes**:
  ```bash
  sudo darwin-rebuild switch --flake ~/nix#cloud
  ```
  
- **Quick rebuild alias** (available after first build):
  ```bash
  rebuild
  ```

## 🛠️ Configuration Management

### System Configuration (`darwin-configuration.nix`)

Manages system-level settings:
- **System packages**: Development tools, applications
- **Homebrew**: GUI applications and system tools
- **macOS defaults**: Dock, Finder, keyboard settings
- **System services**: SSH, GPG, etc.

### User Configuration (`home.nix`)

Manages user-level dotfiles and programs:
- **Shell configuration**: Zsh with aliases and custom prompt
- **Terminal**: Alacritty with custom theme
- **Editor**: Neovim with basic configuration
- **Git**: User settings and aliases
- **CLI tools**: Modern replacements (bat, eza, ripgrep, etc.)

## 📦 Installed Software

### System Packages (Nix)
- **Development**: Git, Neovim, VSCode, Windsurf
- **Terminal**: Alacritty, Tmux
- **Communication**: Telegram Desktop
- **Utilities**: Various CLI tools

### GUI Applications (Homebrew)
- **Browsers**: Google Chrome, Firefox
- **Productivity**: 1Password, Rectangle
- **Media**: IINA
- **Development**: Hammerspoon
- **Utilities**: The Unarchiver, Sublime Text

## 🔧 Customization

### Adding New Packages

**System packages** (available to all users):
```nix
# In darwin-configuration.nix
environment.systemPackages = with pkgs; [
  # Add your package here
  new-package
];
```

**User packages** (user-specific):
```nix
# In home.nix
home.packages = with pkgs; [
  # Add your package here
  new-package
];
```

**GUI applications**:
```nix
# In darwin-configuration.nix
homebrew.casks = [
  # Add your cask here
  "new-app"
];
```

### Modifying Dotfiles

Edit the relevant program configuration in `home.nix`:
- **Zsh**: `programs.zsh`
- **Alacritty**: `programs.alacritty.settings`
- **Neovim**: `programs.neovim.extraConfig`
- **Git**: `programs.git`
- **Tmux**: `programs.tmux.extraConfig`

### System Settings

Modify macOS defaults in `darwin-configuration.nix` under `system.defaults`.

## 🔄 Maintenance Commands

```bash
# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d
# or use the alias:
nix-gc

# Check what will be built/downloaded
sudo darwin-rebuild build --flake ~/nix#cloud

# Rollback to previous generation
sudo darwin-rebuild rollback

# List generations
sudo darwin-rebuild --list-generations
```

## 🐛 Troubleshooting

### Common Issues

1. **Permission errors**: Make sure to use `sudo` with `darwin-rebuild`
2. **Flake not found**: Ensure you're in the correct directory (`~/nix`)
3. **Build failures**: Check syntax in `.nix` files
4. **Home Manager conflicts**: Remove existing dotfiles that conflict

### Useful Commands

```bash
# Check flake syntax
nix flake check

# Show flake info
nix flake show

# Enter development shell with packages
nix develop

# Search for packages
nix search nixpkgs package-name
```

## 📚 Resources

- **Package Search**: https://search.nixos.org/
- **Nixpkgs Repository**: https://github.com/nixos/nixpkgs
- **Nix Darwin**: https://github.com/LnL7/nix-darwin
- **Home Manager**: https://github.com/nix-community/home-manager
- **Nix Language**: https://nixos.org/manual/nix/stable/language/

## 🎯 Features

- ✅ **Declarative**: Everything is code
- ✅ **Reproducible**: Same config = same system
- ✅ **Rollback**: Easy to revert changes
- ✅ **Version controlled**: Full history of changes
- ✅ **Modular**: Separated system and user configs
- ✅ **Modern tools**: Includes modern CLI replacements
- ✅ **Custom dotfiles**: Managed through Home Manager