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
      # Disable key repeat and input duplication fixes
      unset zle_bracketed_paste
      
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
      
      # Disable problematic zsh features that might cause duplication
      unsetopt BEEP
      unsetopt AUTO_MENU
      
      # Source powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      
      # Basic p10k configuration - you can customize this
      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
      
      # Prompt settings
      typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
      typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
      
      # Segment separators
      typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
      typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
      
      # Directory colors
      typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
      typeset -g POWERLEVEL9K_DIR_BACKGROUND=237
      
      # VCS colors
      typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=178
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
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
