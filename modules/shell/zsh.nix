{ config, pkgs, promptStyle, autoStartTmux, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      # Disable built-in theme loading; we'll source Powerlevel10k explicitly
      theme = "";
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
      switch-theme = "~/nix/switch-theme.sh";
    };
    
    initContent = let
      # Define prompt style configurations
      promptStyles = {
        lean = ''
          # Lean style - minimal single line with rounded separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
        '';
        
        classic = ''
          # Classic style - multiline with decorations and rounded separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
          typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='╭─'
          typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='╰─ '
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
        '';
        
        rainbow = ''
          # Rainbow style - colorful with many elements and rounded separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir vcs)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs load ram time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
          # Rainbow colors for different segments
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_LOAD_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_LOAD_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_RAM_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_RAM_BACKGROUND='#${config.lib.stylix.colors.base0D}'
        '';
      };
      
      selectedPromptStyle = promptStyles.${promptStyle};
    in ''
      # History settings
      export HISTSIZE=10000
      export SAVEHIST=10000
      export HISTFILE=~/.zsh_history
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_IGNORE_SPACE
      setopt HIST_NO_STORE
      setopt HIST_EXPAND
      
      # Better cd behavior
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      
      # Disable problematic zsh features that might cause duplication
      unsetopt BEEP
      unsetopt AUTO_MENU
      
      # Fix key repeat and input duplication issues
      unset zle_bracketed_paste
      
      # Source powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      
      # Apply selected prompt style
      ${selectedPromptStyle}
      
      # Disable instant prompt for now
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
      
      # Prompt character colors
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
      
      # Dynamic theme colors from Stylix/nix-colors (common to all styles)
      typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base05}'
      typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base01}'
      typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base07}'
      typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
      typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base0B}'
      typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base08}'
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
      typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#${config.lib.stylix.colors.base0C}'
      
      # Load user Powerlevel10k overrides if present
      [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # Auto-start tmux on interactive local shells (if enabled)
      ${if autoStartTmux then ''
        if [[ -o interactive ]] && command -v tmux >/dev/null; then
          if [[ -z "$TMUX" && -z "$SSH_TTY" ]]; then
            exec tmux
          fi
        fi
      '' else ""}
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
