{
  config,
  pkgs,
  lib,
  nix-colors,
  ...
}: let
  # CHANGE THIS LINE TO SWITCH THEMES
  currentThemeName = "nord"; # Available: dracula, nord, tokyonight, ocean, default

  # CHANGE THIS LINE TO SWITCH PROMPT STYLE
  promptStyle = "classic"; # Available: lean, classic, rainbow

  # CHANGE THIS LINE TO AUTO START TMUX WHEN OPENING A NEW TERMINAL
  autoStartTmux = false;

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
    autoStartTmux = autoStartTmux;
  };
  imports = [
    ./modules/ai/claude
    ./modules/ai/codex
    ./modules/ai/gemini
    ./modules/ai/opencode
    ./modules/cli/fzf.nix
    ./modules/cli/gcloud.nix
    ./modules/desktop/wallpaper.nix
    ./modules/development/colima.nix
    ./modules/development/nodejs.nix
    ./modules/development/protobuf.nix
    ./modules/editor/neovim.nix
    ./modules/git/git.nix
    ./modules/multiplexer/tmux.nix
    ./modules/shell/zsh.nix
    ./modules/terminal/alacritty.nix
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

  # Allow unfree packages in Home Manager
  nixpkgs.config.allowUnfree = true;

  # Packages that should be installed to the user profile.
  # This is the recommended place for user-facing software
  # e.g. CLI tools, developer utilities, GUI apps (if packaged in Nix), etc.
  home.packages = with pkgs; [
    alacritty
    bat
    ffuf
    firefox
    google-chrome
    grpcurl
    ncurses
    telegram-desktop
    tmux-mem-cpu-load
    vscode
    windsurf
    zoom-us
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
