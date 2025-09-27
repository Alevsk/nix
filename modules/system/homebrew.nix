{config, ...}: {
  # nix-darwin Homebrew configuration
  # Policy: Use Homebrew for GUI apps/macOS bundles and select CLI tooling
  # that is better supported via brew; keep lists alphabetized to ease review.
  homebrew = {
    enable = true;

    brews = [
      "gemini-cli" # better support and maintenance in brew than nix store
      "golang-migrate"
      "iproute2mac"
      "mas"
      "minio-mc"
      "node"
      "nvm"
      "watch"
      "yarn"
    ];

    casks = [
      "1password"
      "beekeeper-studio"
      "burp-suite"
      "discord"
      "google-drive"
      "hammerspoon"
      "iina"
      "neo4j-desktop" # not available on nixpkgs
      "ngrok"
      "qflipper"
      "rectangle"
      "slack"
      "spotify"
      "steam"
      "sublime-text"
      "the-unarchiver"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
