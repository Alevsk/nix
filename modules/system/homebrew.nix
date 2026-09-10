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
      "cloud-provider-kind"
      "cocoapods"
      "dive"
      "doctl"
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
      "herdr"
      "higgsfield-ai/tap/higgsfield"
      "hugo"
      "hunk"
      "imagemagick"
      "iproute2mac"
      "k9s"
      "kimi-code"
      "kind"
      "kubectl"
      "kubectx"
      "kubectx"
      "kubeshark"
      "kustomize"
      "labctl"
      "lazygit"
      "libpq"
      "mactop"
      "mas"
      "minio-mc"
      "node"
      "nvm"
      "oci-cli"
      "ollama" # better support via brew on macOS
      "opencode"
      "openjdk@17"
      "openvpn"
      "p7zip"
      "playwright-cli"
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
      "1password"
      "1password-cli"
      "alacritty"
      "android-commandlinetools"
      "another-redis-desktop-manager"
      "antigravity"
      "antigravity-cli"
      "antigravity-ide"
      "balenaetcher"
      "bambu-studio"
      "beekeeper-studio"
      "blender"
      "burp-suite"
      "caido"
      "claude-code"
      "codex"
      "comfy"
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
      "neo4j-desktop"
      "ngrok"
      "obs"
      "obsidian"
      "orbstack"
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
      "zcode"
      "zoom"
    ];

    # Temporarily "none" — Homebrew 5.1.15 requires --force/--force-cleanup/$HOMEBREW_ASK
    # for `brew bundle install --cleanup`, but nix-darwin's activation script doesn't pass
    # them yet. Re-enable once nix-darwin PR #1774 merges:
    # https://github.com/nix-darwin/nix-darwin/pull/1774
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    # upgrade=false: do NOT `brew upgrade` every cask/brew on each rebuild.
    # Rationale: nix-homebrew runs brew as the non-root user, so upgrading any
    # cask whose app is root-owned or App-Management-protected forces a per-cask
    # `sudo`, and sudo's 5-min credential cache expires during the long downloads
    # between casks -> the rebuild prompts for the password repeatedly. The GUI
    # apps here self-update anyway. Activation now only INSTALLS missing casks.
    # To upgrade intentionally, run `brew upgrade` manually (optionally with a
    # `sudo -v` keepalive loop so one password covers the whole run).
    onActivation.upgrade = false;
  };
}
