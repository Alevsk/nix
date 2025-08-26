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
    
    # Set proper permissions for the directory
    chown ${config.system.primaryUser}:staff /Applications/Nix\ Apps
    chmod 755 /Applications/Nix\ Apps
    
    # Find system applications from environment.systemPackages
    if [ -d "${env}/Applications" ]; then
      find "${env}/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
        app_name=$(basename "$app_path")
        src=$(readlink "$app_path")
        echo "linking system app: $src" >&2
        ln -sf "$src" "/Applications/Nix Apps/$app_name"
      done
    fi
    
    # Find Home Manager applications by looking for home-manager-applications in nix store
    for hm_apps_dir in $(find /nix/store -name "*home-manager-applications*" -type d 2>/dev/null | head -1); do
      if [ -d "$hm_apps_dir/Applications" ]; then
        find "$hm_apps_dir/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
          app_name=$(basename "$app_path")
          src=$(readlink "$app_path")
          echo "linking home app: $src" >&2
          ln -sf "$src" "/Applications/Nix Apps/$app_name"
        done
        break
      fi
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
