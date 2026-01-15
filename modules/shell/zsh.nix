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
      promptStyles = {
        # ═══════════════════════════════════════════════════════════════════════
        # LEAN - Zen minimalism. Single line, absolute essentials only.
        # Style: ~/nix main λ
        # ═══════════════════════════════════════════════════════════════════════
        lean = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""

          # Directory - subtle, muted
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=

          # Git - minimal, color = state
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""
          typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Disable extras
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # CLASSIC - The refined two-line. Clean, balanced, informative.
        # Style: ~/nix  main (venv)
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        classic = ''
          # Two-line prompt: info on line 1, prompt char on line 2
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git/VCS
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER="("
          typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=")"
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Prompt character
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          # Status
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # PURE - Exact sindresorhus/pure recreation
        # Style: ~/nix main
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        pure = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separator
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""

          # Directory - blue like Pure
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=none
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - gray (pure style), colored only on dirty
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Execution time - yellow like Pure
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Lambda prompt - magenta
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # POWERLINE - Refined powerline. Clean filled segments with arrows.
        # Style:  ~/nix  main
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        powerline = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time virtualenv)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Powerline arrows - no extra spacing
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base01}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base01}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base01}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base01}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base01}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Status
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base01}'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base06}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # DEVELOPER - For coders. Lambda prompt, truncated context.
        # Style: ~/nix  main (venv)
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        developer = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time node_version go_version rust_version kubecontext)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git status
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
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
          typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰟓'
          typeset -g POWERLEVEL9K_GO_VERSION_PREFIX=""
          typeset -g POWERLEVEL9K_GO_VERSION_SUFFIX=""
          typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_RUST_VERSION_PREFIX=""
          typeset -g POWERLEVEL9K_RUST_VERSION_SUFFIX=""

          # Kubernetes - show only on relevant commands
          typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='⎈'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|k9s|stern'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_KUBECONTEXT_SUFFIX=""

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # UNIX - Classic UNIX style. Nostalgic, professional.
        # Style: [user@host ~/nix branch] λ
        # ═══════════════════════════════════════════════════════════════════════
        unix = ''
          # Classic UNIX style: [user@host dir branch] λ
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Minimal separators
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL="%F{#${config.lib.stylix.colors.base04}}[%f"
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL="%F{#${config.lib.stylix.colors.base04}}]%f "

          # Context (user@host)
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""
          typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=""

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()
          typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # MINIMAL - Ultra-minimal. Directory and lambda only.
        # Style: ~ λ
        # ═══════════════════════════════════════════════════════════════════════
        minimal = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separator
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - just the last component
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=false
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # BOXED - ASCII box drawing. Classic showcase style.
        # Style: ┌─ user in ~/nix on  main
        #        └─λ
        # ═══════════════════════════════════════════════════════════════════════
        boxed = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          # IMPORTANT: Don't use PROMPT_ON_NEWLINE with newline in elements - causes 3 lines
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Box drawing - use MULTILINE prefixes for the two-line effect
          typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}┌─%f"
          typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}└─%f"
          typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{#${config.lib.stylix.colors.base04}}└─%f"
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Context
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX=" %F{#${config.lib.stylix.colors.base04}}in%f "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=" %F{#${config.lib.stylix.colors.base04}}on%f"
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=" %F{#${config.lib.stylix.colors.base04}}via%f "
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER=""
          typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # CAPSULE - Rounded pill/capsule segments. Modern macOS aesthetic.
        # Style:  ~/nix  branch
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        capsule = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Standard powerline arrows
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - cyan capsule
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - green/yellow/orange capsule based on state
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv - purple capsule
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Execution time - muted background
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base02}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base05}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # SLANTED - Slanted powerline variant. Modern edge.
        # Style:  ~/nix  main
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        slanted = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Slanted separators (fire/flame style)
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0BC'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0BD'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0BE'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0BF'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0BC'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0BE'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Status
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base00}'

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base06}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # STARSHIP - Information-rich like Starship prompt.
        # Style: ~/nix on  main via  v22 λ
        # ═══════════════════════════════════════════════════════════════════════
        starship = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs node_version python_version go_version rust_version prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time kubecontext)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separators
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
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX="%F{#${config.lib.stylix.colors.base04}}on%f "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Node.js
          typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_NODE_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base04}}via%f "
          typeset -g POWERLEVEL9K_NODE_VERSION_SUFFIX=""

          # Python
          typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_PYTHON_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐍'
          typeset -g POWERLEVEL9K_PYTHON_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base04}}via%f "
          typeset -g POWERLEVEL9K_PYTHON_VERSION_SUFFIX=""

          # Go
          typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰟓'
          typeset -g POWERLEVEL9K_GO_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base04}}via%f "
          typeset -g POWERLEVEL9K_GO_VERSION_SUFFIX=""

          # Rust
          typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND='none'
          typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=' '
          typeset -g POWERLEVEL9K_RUST_VERSION_PREFIX="%F{#${config.lib.stylix.colors.base04}}via%f "
          typeset -g POWERLEVEL9K_RUST_VERSION_SUFFIX=""

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX="⏱ "
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Kubernetes
          typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='☸'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|k9s|stern'
          typeset -g POWERLEVEL9K_KUBECONTEXT_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_KUBECONTEXT_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # HACKER - Matrix/cyberpunk aesthetic. Green on black.
        # Style: ▶ nix :: main λ
        # ═══════════════════════════════════════════════════════════════════════
        hacker = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separator - use VCS_PREFIX for :: separator instead
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL="%F{#${config.lib.stylix.colors.base0B}}▶%f "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
          typeset -g POWERLEVEL9K_DIR_PREFIX=""
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - matrix green with :: prefix
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=""
          typeset -g POWERLEVEL9K_VCS_PREFIX="%F{#${config.lib.stylix.colors.base0B}}::%f "
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""
          typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=()

          # Lambda prompt - matrix green (no :: before it)
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          # Status - only show errors
          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#${config.lib.stylix.colors.base08}'
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # ARROW - Clean arrow-based prompt. Modern and readable.
        # Style: user@host:~/nix  branch λ
        # ═══════════════════════════════════════════════════════════════════════
        arrow = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separator
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Context
          typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND='none'
          typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
          typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_CONTEXT_PREFIX=""
          typeset -g POWERLEVEL9K_CONTEXT_SUFFIX=""

          # Directory - with colon prefix for user@host:path style
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0D}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX=":"
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # SOFT - Catppuccin-inspired soft aesthetic. Gentle and beautiful.
        # Style: ◆ ~/nix  main
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        soft = ''
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Single space separators - use DIR_PREFIX for ◆ instead of FIRST_SEGMENT_START_SYMBOL
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - soft pink/lavender with ◆ prefix
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
          typeset -g POWERLEVEL9K_DIR_PREFIX="%F{#${config.lib.stylix.colors.base0E}}◆%f "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - gentle colors
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt - soft pastel (no prefix on line 2)
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ '

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='none'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base04}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';

        # ═══════════════════════════════════════════════════════════════════════
        # RAINBOW - Clean powerline with colorful segments
        # Style:  ~/nix   main
        #        λ
        # ═══════════════════════════════════════════════════════════════════════
        rainbow = ''
          # Rainbow powerline: colored segments connected by powerline arrows
          # Example: █ ~/nix█ branch ● ?⏎ λ
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv newline prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time)
          typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
          typeset -g POWERLEVEL9K_ICON_PADDING=none

          # Use standard powerline arrows (these work reliably)
          typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
          typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B1'
          typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B3'
          typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
          typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B0'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B2'
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""

          # Directory - cyan (distinct from vcs green)
          typeset -g POWERLEVEL9K_DIR_BACKGROUND='#${config.lib.stylix.colors.base0C}'
          typeset -g POWERLEVEL9K_DIR_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
          typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
          typeset -g POWERLEVEL9K_DIR_PREFIX=" "
          typeset -g POWERLEVEL9K_DIR_SUFFIX=""

          # Git - green when clean, yellow when modified, orange when untracked
          typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#${config.lib.stylix.colors.base0A}'
          typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#${config.lib.stylix.colors.base09}'
          typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=" "
          typeset -g POWERLEVEL9K_VCS_PREFIX=""
          typeset -g POWERLEVEL9K_VCS_SUFFIX=""

          # Virtualenv - purple
          typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#${config.lib.stylix.colors.base0E}'
          typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#${config.lib.stylix.colors.base00}'
          typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
          typeset -g POWERLEVEL9K_VIRTUALENV_PREFIX=""
          typeset -g POWERLEVEL9K_VIRTUALENV_SUFFIX=""

          # Lambda prompt
          typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#${config.lib.stylix.colors.base0B}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#${config.lib.stylix.colors.base08}'
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ '
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ '

          # Execution time
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#${config.lib.stylix.colors.base03}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#${config.lib.stylix.colors.base06}'
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX=""
          typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_SUFFIX=""

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

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
}
