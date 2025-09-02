{ pkgs, config, ... }:

{
  system.primaryUser = "alevsk";

  nixpkgs.config.allowUnfree = true;

  # These packages are installed system-wide, similar to how you’d configure packages on NixOS.
  environment.systemPackages = with pkgs; [
    buf
    bun
    colima
    curl
    docker
    docker-buildx
    docker-compose
    eza
    fastfetch
    fd
    git
    go
    golangci-lint
    home-manager
    htop
    jq
    lf
    macpm
    mkalias
    ncurses
    neovim
    nodejs
    python3
    ripgrep
    tmux
    tree
    wget
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
      "gemini-cli"  # better support and maintenance in brew than nix store
      "iproute2mac"
      "mas"
      "minio-mc"
      "nvm"
      "watch"
    ];
    casks = [
      "1password"
      "burp-suite"
      "google-drive"
      "hammerspoon"
      "iina"
      "neo4j-desktop" # not available on nixpkgs
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
    
    # Clean up old Nix aliases in /Applications
    find /Applications -name "Nix-*" -type f -delete 2>/dev/null || true
    rm -rf /Applications/Nix\ Apps
    
    # Find system applications from environment.systemPackages
    if [ -d "${env}/Applications" ]; then
      find "${env}/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
        app_name=$(basename "$app_path")
        src=$(readlink "$app_path")
        echo "creating alias for system app: $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
      done
    fi
    
    # Find Home Manager applications by looking for home-manager-applications in nix store
    for hm_apps_dir in $(find /nix/store -name "*home-manager-applications*" -type d 2>/dev/null | head -1); do
      if [ -d "$hm_apps_dir/Applications" ]; then
        find "$hm_apps_dir/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
          app_name=$(basename "$app_path")
          src=$(readlink "$app_path")
          echo "creating alias for home app: $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
        done
        break
      fi
    done
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
      "/Applications/Neo4j\ Desktop\ 2.app"
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
