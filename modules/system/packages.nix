{pkgs, ...}: {
  # System-wide packages (nix-darwin level)
  # Policy: Prefer Nix for CLI/dev tools; keep list alphabetized.
  environment.systemPackages = with pkgs; [
    alejandra
    ast-grep
    buf
    bun
    check-jsonschema
    chisel
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
    hostctl
    htop
    jq
    lf
    macpm
    mdcat
    miller
    mkalias
    mosh
    ncurses
    neo-cowsay
    neovim
    openjdk21
    poppler-utils
    python3
    ripgrep
    rustscan
    tmux
    tomlq
    tree
    uutils-coreutils-noprefix
    wget
    yq
  ];
}
