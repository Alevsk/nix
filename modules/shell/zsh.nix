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
        # ═══════════════════════════════════════════════════════════════════
        # LEAN - Ultra minimal, single line, no backgrounds
        # Inspired by minimalist Unix philosophy. Clean, fast, distraction-free.
        # ═══════════════════════════════════════════════════════════════════
        lean = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # Clean spacing
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=" ❯ "

          # Directory - clean blue
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

          # Git status colors
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Execution time (dimmed)
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # No status indicator
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════
        # CLASSIC - Two-line prompt with elegant box drawing
        # The gold standard. Information-rich but organized.
        # ═══════════════════════════════════════════════════════════════════
        classic = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # No segment separators for clean look
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" · "

          # Directory styling
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Prompt character
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❮'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❮'

          # Status - only show on error
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base08}'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # Time
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
        '';

        # ═══════════════════════════════════════════════════════════════════
        # RAINBOW - Colorful with background segments
        # Eye candy for those who love color. Great for screenshots.
        # ═══════════════════════════════════════════════════════════════════
        rainbow = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs virtualenv)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # Rounded separators for softer look
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B4'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B6'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B5'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B7'

          # OS icon
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base05}'

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Status
          typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # Background jobs
          typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Time
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
        '';

        # ═══════════════════════════════════════════════════════════════════
        # PURE - Inspired by sindresorhus/pure
        # Async-style, two-line, ultra minimal. The hipster's choice.
        # ═══════════════════════════════════════════════════════════════════
        pure = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # Pure-style: lots of space
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # Prompt character - the signature pure arrow
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❮'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❮'

          # No status - prompt char color indicates success/failure
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════
        # POWERLINE - Classic powerline arrows
        # The OG. Requires Nerd Font for proper rendering.
        # ═══════════════════════════════════════════════════════════════════
        powerline = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs virtualenv)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # Classic powerline arrows
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'

          # OS icon
          typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#${config.lib.stylix.colors.base05}'

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Status
          typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # Background jobs
          typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Time
          typeset -g POWERLEVEL9K_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_TIME_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
        '';

        # ═══════════════════════════════════════════════════════════════════
        # DEVELOPER - Shows language versions and tools
        # For when you want to flex your stack. Two-line with lambda prompt.
        # ═══════════════════════════════════════════════════════════════════
        developer = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time node_version go_version rust_version kubecontext)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" · "

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

          # Lambda prompt character
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

          # Language versions - transparent backgrounds
          typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0D}'

          # No explicit status (prompt char color indicates)
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
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

      # Disable problematic zsh features
      unsetopt BEEP
      unset zle_bracketed_paste

      # Enable tab completion with menu selection
      autoload -Uz compinit && compinit
      zmodload -i zsh/complist

      # Enable menu selection and cycling
      zstyle ':completion:*' menu select
      setopt AUTO_LIST AUTO_MENU

      # Configure tab behavior
      bindkey '^I' complete-word
      bindkey -M menuselect '^I' menu-complete
      bindkey -M menuselect '^[[Z' reverse-menu-complete

      # Add colors to completion menu
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Source powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Apply selected prompt style
      ${selectedPromptStyle}

      # Disable instant prompt
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

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
