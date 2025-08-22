{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "kubectl"
        "brew"
        "macos"
        "z"
        "fzf"
        "colored-man-pages"
        "command-not-found"
      ];
      theme = "powerlevel10k/powerlevel10k";
    };
    
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
      
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  };
  
  # Install powerlevel10k theme
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
  
  # Powerlevel10k configuration
  home.file.".p10k.zsh".text = ''
    # Basic p10k configuration
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      dir vcs
    )
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status command_execution_time background_jobs time
    )
    typeset -g POWERLEVEL9K_MODE=nerdfont-complete
    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  '';
}
