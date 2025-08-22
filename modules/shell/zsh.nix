{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      rebuild-system = "sudo darwin-rebuild switch --flake ~/nix#cloud";
      rebuild-home = "home-manager switch --flake ~/nix#alevsk";
      rebuild-all = "sudo darwin-rebuild switch --flake ~/nix#cloud && home-manager switch --flake ~/nix#alevsk";
      nix-gc = "nix-collect-garbage -d";
    };
    
    initContent = ''
      # Custom prompt
      export PS1="%F{blue}%n@%m%f:%F{cyan}%~%f %# "
      
      # History configuration
      export HISTSIZE=10000
      export SAVEHIST=10000
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY
      
      # Better cd behavior
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      
      # Enable fzf key bindings and fuzzy completion
      if command -v fzf >/dev/null 2>&1; then
        source <(fzf --zsh)
      fi
    '';
  };
}
