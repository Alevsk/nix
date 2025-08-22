{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell/zsh.nix
    ./modules/terminal/alacritty.nix
    ./modules/editor/neovim.nix
    ./modules/multiplexer/tmux.nix
    ./modules/git/git.nix
    ./modules/desktop/wallpaper.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "alevsk";
  home.homeDirectory = "/Users/alevsk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # User-specific packages
  home.packages = with pkgs; [
    # Development tools
    curl
    wget
    jq
    tree
    htop
    ripgrep
    fd
    bat
    eza
    
    # Additional CLI tools
    gh  # GitHub CLI
    fzf
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
