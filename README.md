# Alevsk's Nix Darwin Configuration

Declarative macOS setup using Nix Darwin + Home Manager with integrated theming.

![screenshot](docs/terminal.png)

## 📁 Project Structure

```
~/nix/
├── flake.nix                  # Flake with nix-darwin, home-manager, stylix, nix-homebrew
├── darwin-configuration.nix   # System-level config (Nix + Homebrew)
├── home.nix                   # User-level config (Home Manager)
├── modules/                   # Modular configs
│   ├── cli/fzf.nix            # FZF
│   ├── desktop/wallpaper.nix  # Wallpaper setup
│   ├── editor/neovim.nix      # Neovim + theme
│   ├── git/git.nix            # Git
│   ├── multiplexer/tmux.nix   # Tmux + statusline
│   ├── shell/zsh.nix          # Zsh + Powerlevel10k
│   └── terminal/alacritty.nix # Alacritty
└── scripts/
    ├── switch-theme.sh        # Interactive theme/prompt switcher
    └── tmux-stats.sh          # Tmux helper
```

## 🚀 Quick Start

- Install Nix:
  - `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
- Bootstrap nix-darwin (first time only):
  - `sh -c "$(curl -L https://github.com/LnL7/nix-darwin/releases/latest/download/install)"`
- Apply configuration:
  - `cd ~/nix && sudo darwin-rebuild switch --flake .#cloud`
  - `home-manager switch --flake .#alevsk`

## 🔁 Daily Usage

- System changes: `sudo darwin-rebuild switch --flake ~/nix#cloud`
- User changes: `home-manager switch --flake ~/nix#alevsk`
- Helpful aliases (available in the shell):
  - `rebuild-system`, `rebuild-home`, `rebuild-all`, `switch-theme`, `nix-gc`

## ➕ Add Packages

- Nix (system): edit `modules/system/packages.nix`
  - `environment.systemPackages = with pkgs; [ my-package ];` (keep list alphabetized)
- Nix (user): edit `home.nix`
  - `home.packages = with pkgs; [ my-package ];`
- Homebrew (CLI): edit `modules/system/homebrew.nix`
  - `homebrew.brews = [ "my-brew" ];` (keep list alphabetized)
- Homebrew (Apps): edit `modules/system/homebrew.nix`
  - `homebrew.casks = [ "my-app" ];` (keep list alphabetized)

## 🧰 Apply/Bootstrap Notes

- Flake attributes: system `.#cloud`, user `.#alevsk`.
- Homebrew is managed via `nix-homebrew` and `homebrew.*` in `darwin-configuration.nix`.
- Dock items and “Nix Apps” symlinks are set automatically during activation.

## 📦 Package Policy

- Use Nix for CLI/dev tools and libraries (reproducible, easy pinning via flakes).
- Use Homebrew for GUI apps/macOS bundles (better support and updates for many apps).
- Dock apps should point to Homebrew-managed apps under `/Applications` where possible.

## 🔄 Maintenance

- Update inputs: `nix flake update`
- Garbage collect: `nix-collect-garbage -d`
- Validate flake: `nix flake check`
- Inspect flake: `nix flake show`
- Search packages: `nix search nixpkgs <name>`
- Rollback: `sudo darwin-rebuild rollback` (system), `home-manager rollback` (user)

## 🎨 Theming

- Fast switch (interactive): run `switch-theme` or `~/nix/scripts/switch-theme.sh`
- Manual edit: update in `home.nix`
  - `currentThemeName = "nord";`    # nord, dracula, tokyonight, ocean, default
  - `promptStyle = "lean";`         # lean, classic, rainbow
  - `autoStartTmux = false;`         # auto-start tmux on new terminals
- Apply theme changes: `home-manager switch --flake ~/nix#alevsk`
- Integration: Stylix + nix-colors propagate colors to Zsh, tmux, fzf, Neovim, Alacritty.

## 🔧 Module Locations

- Zsh: `modules/shell/zsh.nix`
- Alacritty: `modules/terminal/alacritty.nix`
- Neovim: `modules/editor/neovim.nix`
- Git: `modules/git/git.nix`
- Tmux: `modules/multiplexer/tmux.nix`
- FZF: `modules/cli/fzf.nix`
- Wallpaper: `modules/desktop/wallpaper.nix`

## 🐛 Troubleshooting

- Use `sudo` with `darwin-rebuild` for system changes.
- Ensure you run from `~/nix` or point `--flake` at the repo.
- If builds fail, check `.nix` syntax and attribute names (`cloud`, `alevsk`).

## 📚 Resources

- Nix packages: https://search.nixos.org/
- nix-darwin: https://github.com/LnL7/nix-darwin
- Home Manager: https://github.com/nix-community/home-manager
- Stylix: https://github.com/nix-community/stylix
- nix-colors: https://github.com/Misterio77/nix-colors
