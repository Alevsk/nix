{config, ...}: {
  # nix-darwin Homebrew configuration
  # Policy: Use Homebrew for GUI apps/macOS bundles and select CLI tooling
  # that is better supported via brew; keep lists alphabetized to ease review.
  homebrew = {
    enable = true;

    brews = [
      "ripgrep"
      "ansible"
      "awscli"
      "dive"
      "duckdb"
      "ffmpeg"
      "gemini-cli" # better support and maintenance in brew than nix store
      "gitleaks"
      "gogcli"
      "golang-migrate"
      "gopeed"
      "helm"
      "hugo"
      "imagemagick"
      "iproute2mac"
      "k9s"
      "kind"
      "kubectl"
      "kubectx"
      "kubeshark"
      "kustomize"
      "labctl"
      "mactop"
      "mas"
      "minio-mc"
      "node"
      "nvm"
      "ollama" # better support via brew on macOS
      "opencode"
      "p7zip"
      "python@3.13"
      "qpdf"
      "scoutsuite"
      "sshpass"
      "trufflehog"
      "uv"
      "watch"
      "yarn"
      "zoxide"
    ];

    casks = [
      "1password-cli"
      "1password"
      "another-redis-desktop-manager"
      "antigravity"
      "beekeeper-studio"
      "burp-suite"
      "caido"
      "claude-code"
      "codex"
      "discord"
      "docker-desktop"
      "dropbox"
      "google-drive"
      "hammerspoon"
      "iina"
      "inkscape"
      "karabiner-elements"
      "lm-studio"
      "macdown"
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
