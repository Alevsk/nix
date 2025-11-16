{config, ...}: {
  # nix-darwin Homebrew configuration
  # Policy: Use Homebrew for GUI apps/macOS bundles and select CLI tooling
  # that is better supported via brew; keep lists alphabetized to ease review.
  homebrew = {
    enable = true;

    brews = [
      "duckdb"
      "gemini-cli" # better support and maintenance in brew than nix store
      "golang-migrate"
      "iproute2mac"
      "mas"
      "minio-mc"
      "node"
      "nvm"
      "opencode"
      "watch"
      "yarn"
    ];

    casks = [
      "1password"
      "beekeeper-studio"
      "burp-suite"
      "claude-code"
      "codex"
      "discord"
      "dropbox"
      "google-drive"
      "hammerspoon"
      "iina"
      "lm-studio"
      "neo4j-desktop" # not available on nixpkgs
      "ngrok"
      "qflipper"
      "raspberry-pi-imager"
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
