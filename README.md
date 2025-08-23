# Alevsk's Nix Darwin Configuration

A declarative macOS system configuration using Nix Darwin and Home Manager.

## 📁 Project Structure

```
~/nix/
├── flake.nix                 # Main flake configuration with inputs
├── flake.lock               # Lock file for reproducible builds
├── darwin-configuration.nix  # System-level configuration (apps, settings, homebrew)
├── home.nix                 # User-level configuration (imports modules)
├── modules/                 # Modular Home Manager configurations
│   ├── shell/
│   │   └── zsh.nix          # Zsh configuration with aliases and prompt
│   ├── terminal/
│   │   └── alacritty.nix    # Alacritty terminal configuration
│   ├── editor/
│   │   └── neovim.nix       # Neovim editor configuration
│   ├── multiplexer/
│   │   └── tmux.nix         # Tmux terminal multiplexer configuration
│   └── git/
│       └── git.nix          # Git version control configuration
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
   home-manager switch --flake .#alevsk
   ```

### Daily Usage

- **Apply system configuration changes**:
  ```bash
  sudo darwin-rebuild switch --flake ~/nix#cloud
  ```

- **Apply user dotfiles changes**:
  ```bash
  home-manager switch --flake ~/nix#alevsk
  ```
  
- **Apply both system and user changes**:
  ```bash
  sudo darwin-rebuild switch --flake ~/nix#cloud && home-manager switch --flake ~/nix#alevsk
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
- **Shell configuration**: Zsh with aliases and dynamic Powerlevel10k prompt styles
- **Terminal**: Alacritty with Stylix theme integration
- **Editor**: Neovim with basic configuration
- **Git**: User settings and aliases
- **CLI tools**: Modern replacements (bat, eza, ripgrep, etc.)
- **Theming**: Integrated nix-colors + Stylix for consistent theming

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

## 🎨 Themes and Styling

### Available Themes

Change themes by editing `currentThemeName` in `home.nix`:

```nix
# Available: dracula, nord, tokyonight, ocean, default
currentThemeName = "nord";
```

**Available themes:**
- **`nord`** - Cool blue/gray Nordic theme
- **`dracula`** - Popular purple/pink theme
- **`tokyonight`** - Dark blue Tokyo Night theme
- **`ocean`** - Blue/teal ocean theme
- **`default`** - Catppuccin Mocha theme

### Powerlevel10k Prompt Styles

Change prompt styles by editing `promptStyle` in `home.nix`:

```nix
# Available: lean, classic, rainbow
promptStyle = "classic";
```

**Available styles:**
- **`lean`** - Minimal single-line prompt with essential info
- **`classic`** - Multi-line prompt with decorative borders
- **`rainbow`** - Colorful prompt with system information

### Theme Integration

- **Stylix**: Provides consistent theming across applications
- **nix-colors**: Base16 color schemes for terminal applications
- **Dynamic colors**: All prompt styles automatically adapt to selected theme
- **Consistent fonts**: FiraCode Nerd Font across all applications

### Applying Changes

After modifying themes or prompt styles:
```bash
home-manager switch --flake ~/nix#alevsk
```

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

Edit the relevant module file:
- **Zsh**: `modules/shell/zsh.nix` (includes Powerlevel10k prompt styles)
- **Alacritty**: `modules/terminal/alacritty.nix` (Stylix-themed)
- **Neovim**: `modules/editor/neovim.nix`
- **Git**: `modules/git/git.nix`
- **Tmux**: `modules/multiplexer/tmux.nix`

### Creating Custom Prompt Styles

To add a new Powerlevel10k style, edit `modules/shell/zsh.nix`:

1. Add your style to the `promptStyles` attribute set
2. Define prompt elements and colors using Stylix variables
3. Update the `promptStyle` options in `home.nix`

### Creating Custom Themes

To add a new theme:

1. Add the theme to nix-colors (if not available)
2. Update the `themeMap` in `home.nix`
3. Add the theme name to available options

### Adding New Program Modules

1. **Create a new module directory** (e.g., `modules/browser/`):
   ```bash
   mkdir -p modules/browser
   ```

2. **Create the module file** (e.g., `modules/browser/firefox.nix`):
   ```nix
   { config, pkgs, ... }:
   {
     programs.firefox = {
       enable = true;
       # configuration here
     };
   }
   ```

3. **Import the module in `home.nix`**:
   ```nix
   imports = [
     # existing imports...
     ./modules/browser/firefox.nix
   ];
   ```

### System Settings

Modify macOS defaults in `darwin-configuration.nix` under `system.defaults`.

## 🔄 Maintenance Commands

```bash
# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d

# Check what will be built/downloaded (system)
sudo darwin-rebuild build --flake ~/nix#cloud

# Check what will be built/downloaded (user)
home-manager build --flake ~/nix#alevsk

# Rollback to previous generation (system)
sudo darwin-rebuild rollback

# Rollback to previous generation (user)
home-manager rollback

# List generations (system)
sudo darwin-rebuild --list-generations

# List generations (user)
home-manager generations

# Read Home Manager news
home-manager news
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
- ✅ **Standalone Home Manager**: User configs independent from system
- ✅ **Dynamic theming**: Integrated Stylix + nix-colors theming system
- ✅ **Multiple prompt styles**: Switchable Powerlevel10k configurations
- ✅ **Consistent styling**: Colors and fonts unified across applications

## 📋 Architecture

This setup uses a **two-tier approach**:

1. **System Level** (`darwin-configuration.nix`): Managed by nix-darwin
   - System packages and services
   - Homebrew applications
   - macOS system defaults
   - Fonts and system-wide settings

2. **User Level** (`home.nix`): Managed by Home Manager standalone
   - User dotfiles (zsh, git, neovim, etc.)
   - User-specific packages
   - Application configurations (alacritty, tmux)
   - Shell aliases and environment

This separation provides better isolation and allows user configurations to be managed independently from system changes.