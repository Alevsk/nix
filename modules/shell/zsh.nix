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
      
      # Restore original p10k configuration with multiline prompt
      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
      
      # Prompt settings - restore multiline format
      typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='╭─'
      typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='╰─ '
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
      
      # Segment separators - use powerline style
      typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
      typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
      
      # Prompt character
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=76
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=196
      
      # Dynamic theme colors from Stylix/nix-colors
      typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base05}'
      typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base01}'
      typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
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
