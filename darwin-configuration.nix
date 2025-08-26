{ pkgs, config, ... }:

{
  system.primaryUser = "alevsk";

  nixpkgs.config.allowUnfree = true;

  # These packages are installed system-wide, similar to how you’d configure packages on NixOS.
  environment.systemPackages = with pkgs; [
    docker
    fastfetch
    git
    go
    golangci-lint
    home-manager
    macpm
    mkalias
    neovim
    ncurses
    tmux
    curl
    wget
    jq
    fd
    tree
    htop
    eza
    ripgrep
    python3
    nodejs
    yarn
  ];

  environment.extraOutputsToInstall = [ "terminfo" ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.droid-sans-mono
  ];

  # Useful when something is not well-maintained or not available in Nixpkgs (e.g., some proprietary macOS apps).
  # keep sorted alphabetically
  homebrew = {
    enable = true;
    brews = [
      "iproute2mac"
      "mas"
      "nvm"
      "watch"
    ];
    casks = [
      "1password"
      "hammerspoon"
      "iina"
      "rectangle"
      "sublime-text"
      "the-unarchiver"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
    # Set up applications.
    echo "setting up /Applications..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r src; do
      app_name=$(basename "$src")
      echo "copying $src" >&2
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done

    # Ensure Spotlight indexes the Nix Apps directory
    if command -v mdutil >/dev/null 2>&1; then
      mdutil -i on "/Applications/Nix Apps" >/dev/null 2>&1 || true
      mdutil -E "/Applications/Nix Apps" >/dev/null 2>&1 || true
    fi
  '';

  system.defaults = {
    dock.autohide = false;
    dock.persistent-apps = [
      "/System/Applications/Launchpad.app"
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "${pkgs.telegram-desktop}/Applications/Telegram.app"
      "${pkgs.windsurf}/Applications/Windsurf.app"
      "/Applications/1Password.app"
      "${pkgs.google-chrome}/Applications/Google Chrome.app"
      "/Applications/Sublime\ Text.app"
      "/System/Applications/System\ Settings.app"
    ];
    dock = {
      show-process-indicators = true;
      show-recents = false;
      static-only = false;
    };
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on catalina
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
