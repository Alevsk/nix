{config, ...}: {
  # nix-darwin Homebrew configuration
  # Policy: Use Homebrew for GUI apps/macOS bundles and select CLI tooling
  # that is better supported via brew; keep lists alphabetized to ease review.
  homebrew = {
    enable = true;

    brews = [
      "ansible"
      "ast-grep"
      "awscli"
      "cliclick"
      "cocoapods"
      "dive"
      "duckdb"
      "ffmpeg"
      "gemini-cli" # better support and maintenance in brew than nix store
      "gentleman-programming/tap/engram"
      "gh"
      "git-lfs"
      "gitleaks"
      "gogcli"
      "golang-migrate"
      "gopeed"
      "gradle"
      "graphviz"
      "helm"
      "higgsfield-ai/tap/higgsfield"
      "hugo"
      "imagemagick"
      "iproute2mac"
      "k9s"
      "kimi-code"
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
      "openjdk@17"
      "p7zip"
      "python@3.13"
      "qpdf"
      "ripgrep"
      "rtk"
      "rustup"
      "scoutsuite"
      "sshpass"
      "stripe-cli"
      "swiftlint"
      "trufflehog"
      "uv"
      "watch"
      "xcodegen"
      "yarn"
      "zoxide"
    ];

    casks = [
      "1password-cli"
      "1password"
      "alacritty"
      "android-commandlinetools"
      "another-redis-desktop-manager"
      "antigravity-cli"
      "antigravity-ide"
      "antigravity"
      "balenaetcher"
      "bambu-studio"
      "beekeeper-studio"
      "burp-suite"
      "caido"
      "claude-code"
      "codex"
      "devin-desktop"
      "discord"
      "docker-desktop"
      "dropbox"
      "firefox"
      "flutter"
      "godot"
      "google-chrome"
      "google-drive"
      "hammerspoon"
      "iina"
      "inkscape"
      "iterm2"
      "karabiner-elements"
      "little-snitch"
      "lm-studio"
      "macdown"
      "neo4j-desktop" # not available on nixpkgs
      "ngrok"
      "obs"
      "qflipper"
      "raspberry-pi-imager"
      "rectangle"
      "slack"
      "spotify"
      "steam"
      "sublime-text"
      "telegram"
      "the-unarchiver"
      "typewhisper/tap/typewhisper"
      "utm"
      "visual-studio-code"
      "wireshark-app"
      "zoom"
    ];

    # Temporarily "none" — Homebrew 5.1.15 requires --force/--force-cleanup/$HOMEBREW_ASK
    # for `brew bundle install --cleanup`, but nix-darwin's activation script doesn't pass
    # them yet. Re-enable once nix-darwin PR #1774 merges:
    # https://github.com/nix-darwin/nix-darwin/pull/1774
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
