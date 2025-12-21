{config, ...}: {
  # nix-darwin Homebrew configuration
  # Policy: Use Homebrew for GUI apps/macOS bundles and select CLI tooling
  # that is better supported via brew; keep lists alphabetized to ease review.
  homebrew = {
    enable = true;

    brews = [
      "dive"
      "duckdb"
      "gemini-cli" # better support and maintenance in brew than nix store
      "gitleaks"
      "golang-migrate"
      "imagemagick"
      "iproute2mac"
      "k9s"
      "kubectl"
      "kubectx"
      "kubeshark"
      "mas"
      "minio-mc"
      "node"
      "nvm"
      "ollama" # better support via brew on macOS
      "opencode"
      "python@3.13"
      "scoutsuite"
      "trufflehog"
      "watch"
      "yarn"
    ];

    casks = [
      "1password"
      "antigravity"
      "beekeeper-studio"
      "burp-suite"
      "claude-code"
      "codex"
      "discord"
      "dropbox"
      "google-drive"
      "hammerspoon"
      "iina"
      "inkscape"
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
      "utm"
      "wireshark"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
