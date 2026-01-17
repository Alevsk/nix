{
  config,
  pkgs,
  lib,
  promptStyle,
  promptEngine,
  autoStartTmux,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
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
      # ═══════════════════════════════════════════════════════════════════════
      # POWERLEVEL10K PROMPT STYLES - 15 Distinct r/unixporn-worthy designs
      # Each style has a unique visual identity and purpose
      # ═══════════════════════════════════════════════════════════════════════
      promptStyles = {

        # ─────────────────────────────────────────────────────────────────────
        # MINIMAL - "Negative Space"
        # The absolute minimum. Just breathe.
        # Format: ~ ›
        # ─────────────────────────────────────────────────────────────────────
        minimal = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""

          # Directory - muted, single folder
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=

          # Prompt char - subtle ›
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='› '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='› '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='› '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='› '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # LEAN - "Zen Single-Line"
        # Everything you need, nothing you don't.
        # Format: nix main ❯
        # ─────────────────────────────────────────────────────────────────────
        lean = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""

          # Directory - bold blue
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=

          # Git - magenta branch, orange status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="*"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=

          # Prompt char - bold green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # PURE - Exact sindresorhus/pure recreation
        # The original minimal async prompt
        # Format: ~/nix main *
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        pure = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""
          typeset -g POWERLEVEL9K_RIGHT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_RIGHT_RIGHT_WHITESPACE=""

          # Directory - bold blue (Pure style)
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=none
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - gray clean, yellow dirty (Pure style)
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON=""
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="*"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=""
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true

          # Execution time - yellow (Pure style)
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - magenta ❯ (Pure style)
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # CLASSIC - "Refined Two-Line"
        # Balanced, informative, elegant
        # Format: ~/nix  main (!+?)
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        classic = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""
          typeset -g POWERLEVEL9K_RIGHT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_RIGHT_RIGHT_WHITESPACE=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - with  icon
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER="("
          typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=")"
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - magenta ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # POWERLINE - "Solid Segments"
        # Classic powerline with arrow separators
        # Format:  ~/nix   main
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        powerline = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Powerline arrows
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B6'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B4'

          # Directory - blue
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=" "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - green
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=" "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=" "

          # Prompt char - green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # CAPSULE - "Rounded Pills"
        # True capsule segments with rounded ends
        # Format:  ~/nix   main
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        capsule = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Rounded capsule separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B4'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B5'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B6'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B7'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B6'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B4'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B6'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B4'

          # Directory - cyan pill
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=" "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - green pill
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Virtualenv - purple pill
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=" "
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=" "

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=" "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=" "

          # Prompt char - green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # SLANTED - "Sharp Angles"
        # Modern slanted separators for a dynamic look
        # Format:  ~/nix   main
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        slanted = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Slanted separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0BC'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0BD'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0BE'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0BF'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0BC'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0BE'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - blue
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=" "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - magenta
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base06}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=" "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=" "

          # Prompt char - magenta ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # RAINBOW - "Color Gradient"
        # True rainbow: spectrum color progression
        # Format:  user   nix   main
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        rainbow = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Powerline arrows
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B6'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B4'

          # Context - magenta (first in rainbow)
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=" "
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=" "

          # Directory - blue
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_PREFIX=" "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - green/cyan progression
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="~"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="•"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Execution time - orange
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=" "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=" "

          # Prompt char - green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # HACKER - "Terminal Operator"
        # Clean, dense, professional. Not cliché green.
        # Format: [nix:main*] ▸
        # ─────────────────────────────────────────────────────────────────────
        hacker = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

          # Clean separators - we'll use prefix/suffix for brackets
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL="%F{#${config.lib.stylix.colors.base04}}[%f"
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""

          # Directory - cyan
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=

          # Git - colon separator, magenta branch
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="*"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=":"
          typeset -g POWERLEVEL9K_VCS_SUFFIX="%F{#${config.lib.stylix.colors.base04}}]%f "
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=

          # Execution time - muted
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - cyan ▸
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='▸ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='▸ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='▸ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='▸ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # BOXED - "Framed"
        # Elegant box drawing, clear visual hierarchy
        # Format: ╭─ ~/nix on  main
        #         ╰─ ❯
        # ─────────────────────────────────────────────────────────────────────
        boxed = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Box drawing prefixes
          typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}╭─%f "
          typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}╰─%f "
          typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}╰─%f "
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - with "on" prefix
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" %F{#${config.lib.stylix.colors.base04}}on%f"
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv - with "via" prefix
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=" %F{#${config.lib.stylix.colors.base04}}via%f  "
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER=""
          typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=""

          # Execution time - with "took" prefix
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX="%F{#${config.lib.stylix.colors.base04}}took%f "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # DEVELOPER - "IDE Status Bar"
        # Info-rich but organized, for polyglot developers
        # Format: ~/nix  main   v22  v1.21
        #         λ
        # ─────────────────────────────────────────────────────────────────────
        developer = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time node_version go_version rust_version kubecontext)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Language versions
          typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_NODE_VERSION_PREFIX=""
          typeset -g POWERLEVEL9K_NODE_VERSION_SUFFIX=""
          typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_GO_VERSION_PREFIX=""
          typeset -g POWERLEVEL9K_GO_VERSION_SUFFIX=""
          typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_RUST_VERSION_PREFIX=""
          typeset -g POWERLEVEL9K_RUST_VERSION_SUFFIX=""

          # Kubernetes
          typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='☸'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|k9s|stern'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_KUBECONTEXT_SUFFIX=""

          # Prompt char - λ (developer style)
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # UNIX - "Classic Shell"
        # Traditional PS1 style, no fancy glyphs
        # Format: user@host:~/nix$
        # ─────────────────────────────────────────────────────────────────────
        unix = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""

          # Context - user@host
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION=""

          # Directory - with colon prefix
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX=":"
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=""

          # Git - in parentheses
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="*"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=" ("
          typeset -g POWERLEVEL9K_VCS_SUFFIX=")"
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=""

          # Prompt char - classic $
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='$ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='$ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='$ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='$ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # STARSHIP - "Official Starship Look"
        # Matches the default Starship aesthetic
        # Format: nix on  main via  v22
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        starship = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs node_version go_version rust_version newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Clean separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - cyan bold
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - with "on" prefix
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX="%F{#${config.lib.stylix.colors.base05}}on%f "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "

          # Language versions - with "via" prefix
          typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_NODE_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base05}}via%f "
          typeset -g POWERLEVEL9K_NODE_VERSION_SUFFIX=""
          typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_GO_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base05}}via%f "
          typeset -g POWERLEVEL9K_GO_VERSION_SUFFIX=""
          typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_RUST_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base05}}via%f "
          typeset -g POWERLEVEL9K_RUST_VERSION_SUFFIX=""

          # Execution time - with "took" prefix
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX="%F{#${config.lib.stylix.colors.base05}}took%f "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - green ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # SOFT - "Pastel Dreams"
        # Catppuccin-inspired soft aesthetic
        # Format: ● ~/nix  main
        #         ❯
        # ─────────────────────────────────────────────────────────────────────
        soft = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

          # Clean separators - use DIR_PREFIX for ●
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - soft magenta with ● prefix
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX="%F{#${config.lib.stylix.colors.base0E}}●%f "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" "

          # Git - soft green
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="~"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="•"
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Prompt char - soft magenta ❯
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❯ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ─────────────────────────────────────────────────────────────────────
        # ARROW - "Flow State"
        # Arrow-based visual flow, clean and directional
        # Format: alevsk → nix → main →
        # ─────────────────────────────────────────────────────────────────────
        arrow = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

          # Arrow separator
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_LEFT_WHITESPACE=""
          typeset -g POWERLEVEL9K_LEFT_RIGHT_WHITESPACE=""

          # Context - magenta username
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=" %F{#${config.lib.stylix.colors.base04}}→%f "
          typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION=""

          # Directory - blue with arrow suffix
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=" %F{#${config.lib.stylix.colors.base04}}→%f "
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=""

          # Git - green
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_STAGED_ICON="+"
          typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON="*"
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=" "
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=""

          # Prompt char - green →
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='→ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='→ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='→ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='→ '

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

      # Prompt engine initialization (conditional based on promptEngine setting)
      ${
        if promptEngine == "powerlevel10k"
        then ''
          # Source powerlevel10k theme
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

          # Apply selected prompt style
          ${selectedPromptStyle}

          # Disable instant prompt
          typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
        ''
        else ''
          # Starship prompt is initialized via programs.starship
        ''
      }

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

  # Only include p10k package when using that engine
  home.packages = lib.mkIf (promptEngine == "powerlevel10k") (with pkgs; [
    zsh-powerlevel10k
  ]);
}
