{ config, pkgs, lib, nix-colors, ... }:

let
  # CHANGE THIS LINE TO SWITCH THEMES
  currentThemeName = "nord"; # Available: dracula, nord, tokyonight, ocean, default
  
  # CHANGE THIS LINE TO SWITCH PROMPT STYLE
  promptStyle = "lean"; # Available: lean, classic, rainbow
  
  # Theme mapping for nix-colors schemes
  themeMap = {
    "nord" = nix-colors.colorSchemes.nord;
    "dracula" = nix-colors.colorSchemes.dracula;
    "tokyonight" = nix-colors.colorSchemes.tokyo-night-dark;
    "ocean" = nix-colors.colorSchemes.ocean;
    "default" = nix-colors.colorSchemes.catppuccin-mocha;
  };
  
  # Get the selected theme
  selectedTheme = themeMap.${currentThemeName};

  # Map current theme to tinted-tmux base16 scheme
  tintedTmuxSchemeMap = {
    "nord" = "base16-nord";
    "dracula" = "base16-dracula";
    "tokyonight" = "base16-tokyo-night-dark";
    "ocean" = "base16-ocean";
    "default" = "base16-catppuccin-mocha";
  };
  tmuxTintScheme = tintedTmuxSchemeMap.${currentThemeName};
in {
  # Make theme and prompt style available to modules
  _module.args = {
    terminalTheme = selectedTheme;
    promptStyle = promptStyle;
    tmuxTintScheme = tmuxTintScheme;
    # Expose theme name so modules can map to plugins
    currentThemeName = currentThemeName;
  };
  imports = [
    ./modules/shell/zsh.nix
    ./modules/terminal/alacritty.nix
    ./modules/multiplexer/tmux.nix
    ./modules/editor/neovim.nix
    ./modules/cli/fzf.nix
    ./modules/desktop/wallpaper.nix
    ./modules/git/git.nix
  ];

  # Set nix-colors colorScheme (used by nix-colors modules)
  colorScheme = selectedTheme;

  # Enable Stylix with nix-colors integration
  stylix = {
    enable = true;
    base16Scheme = selectedTheme;
    
    # Configure fonts
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGS Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
    
    # Set cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };

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
    nerd-fonts.meslo-lg

    # AI
    ollama
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
