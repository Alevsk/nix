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
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
