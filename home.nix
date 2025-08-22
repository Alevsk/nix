{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell/zsh.nix
    ./modules/terminal/alacritty.nix
    ./modules/multiplexer/tmux.nix
    ./modules/editor/neovim.nix
    ./modules/desktop/wallpaper.nix
    ./modules/git/git.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "alevsk";
  home.homeDirectory = "/Users/alevsk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Terminal and shell utilities
    bat
    eza
    fzf
    ripgrep
    fd
    tree
    htop
    git
    curl
    wget
    jq
    ncurses
    
    # Development tools
    nodejs
    python3
    go
    
    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    # AI
    ollama
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
