{config, ...}: {
  # Homebrew configuration (kept alphabetically sorted as noted)
  homebrew = {
    enable = true;

    brews = [
      "gemini-cli" # better support and maintenance in brew than nix store
      "golang-migrate"
      "iproute2mac"
      "mas"
      "minio-mc"
      "nvm"
      "watch"
    ];

    casks = [
      "1password"
      "beekeeper-studio"
      "burp-suite"
      "google-drive"
      "hammerspoon"
      "iina"
      "neo4j-desktop" # not available on nixpkgs
      "qflipper"
      "rectangle"
      "slack"
      "sublime-text"
      "the-unarchiver"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
