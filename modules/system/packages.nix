{pkgs, ...}: {
  # System-wide packages (nix-darwin level)
  # Policy: Prefer Nix for CLI/dev tools; keep list alphabetized.
  environment.systemPackages = with pkgs; [
    alejandra
    ast-grep
    buf
    bun
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
    htop
    jq
    lf
    macpm
    mdcat
    mkalias
    ncurses
    neo-cowsay
    neovim
    python3
    ripgrep
    tmux
    tree
    uutils-coreutils-noprefix
    wget
  ];
}
