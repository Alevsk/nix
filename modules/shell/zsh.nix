{
  config,
  pkgs,
  promptStyle,
  autoStartTmux,
  ...
}: {
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
        "brew"
        "colored-man-pages"
        "command-not-found"
        "docker"
        "fzf"
        "git"
        "kubectl"
        "macos"
        "z"
      ];
    };

    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      rebuild-system = "make -C ${config.home.homeDirectory}/nix rebuild-system";
      rebuild-home = "make -C ${config.home.homeDirectory}/nix rebuild-home";
      rebuild-all = "make -C ${config.home.homeDirectory}/nix rebuild-all";
      nix-update = "make -C ${config.home.homeDirectory}/nix nix-update";
      nix-upgrade = "make -C ${config.home.homeDirectory}/nix nix-upgrade";
      nix-gc = "make -C ${config.home.homeDirectory}/nix nix-gc";
      switch-theme = "${config.home.homeDirectory}/nix/scripts/switch-theme.sh";
      tmux-stats = "${config.home.homeDirectory}/nix/scripts/tmux-stats.sh";
    };

    initContent = let
      # Define prompt style configurations
      promptStyles = {
        lean = ''
          # Lean style - minimal single line with angled separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
          # Lean-specific colors
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_LOAD_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_LOAD_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_RAM_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_RAM_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
        '';

        classic = ''
          # Classic style - multiline with decorations and powerline separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='╭─'
          typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='╰─ '
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
          # Classic-specific colors with more contrast
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_LOAD_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_LOAD_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_RAM_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_RAM_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
        '';

        rainbow = ''
          # Rainbow style - colorful with many elements and rounded separators
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
          # Rainbow colors for different segments
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_LOAD_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_LOAD_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_RAM_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_RAM_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base07}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
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

      # Fix key repeat and input duplication issues
      unset zle_bracketed_paste

      # Enable tab completion with menu selection
      autoload -Uz compinit && compinit
      zmodload -i zsh/complist

      # Enable menu selection and cycling
      zstyle ':completion:*' menu select
      setopt AUTO_LIST AUTO_MENU

      # Configure tab behavior for completion
      bindkey '^I' complete-word
      bindkey -M menuselect '^I' menu-complete
      bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift-Tab

      # Add colors to completion menu
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Source powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Apply selected prompt style
      ${selectedPromptStyle}

      # Disable instant prompt for now
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

      # Prompt character colors
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
      # typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_BACKGROUND='#${config.lib.stylix.colors.base01}'

      # Common theme colors from Stylix/nix-colors (shared across all styles)
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
      typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base09}'
      typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#${config.lib.stylix.colors.base0C}'
      typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='#${config.lib.stylix.colors.base01}'

      # Use Colima's Docker socket if available
      if [ -S "$HOME/.colima/default/docker.sock" ]; then
        export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
      fi

      # Auto-start tmux on interactive local shells (if enabled)
      ${
        if autoStartTmux
        then ''
          if [[ -o interactive ]] && command -v tmux >/dev/null; then
            if [[ -z "$TMUX" && -z "$SSH_TTY" ]]; then
              exec tmux
            fi
          fi
        ''
        else ""
      }
    '';
  };

  # Install powerlevel10k theme
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
}
