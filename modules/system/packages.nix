{ pkgs, ... }:

{
  # System-wide packages (nix-darwin level)
  environment.systemPackages = with pkgs; [
    alejandra
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
    mkalias
    ncurses
    neo-cowsay
    neovim
    nodejs
    python3
    ripgrep
    tmux
    tree
    uutils-coreutils-noprefix
    wget
    yarn
  ];
}
