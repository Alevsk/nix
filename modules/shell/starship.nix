{
  config,
  pkgs,
  lib,
  promptStyle,
  promptEngine,
  ...
}: let
  # Base16 color references from Stylix
  colors = config.lib.stylix.colors;

  # Helper to create hex color string
  c = base: "#${colors.${base}}";

  # ═══════════════════════════════════════════════════════════════════════════
  # STARSHIP PROMPT STYLES - All 15 styles mapped to Starship format
  # Matched to Powerlevel10k equivalents for consistency
  # ═══════════════════════════════════════════════════════════════════════════

  starshipStyles = {
    # ─────────────────────────────────────────────────────────────────────────
    # LEAN - Minimal single-line: nix  main+! λ
    # P10k: truncate_to_last, length=1, no VCS prefix
    # ─────────────────────────────────────────────────────────────────────────
    lean = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      directory = {
        style = "fg:${c "base05"}";
        format = "[$path]($style) ";
        truncation_length = 1;
        truncate_to_repo = false;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
        conflicted = "=";
        deleted = "x";
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # CLASSIC - Two-line balanced: ~/nix  main+! (venv) + newline + λ
    # P10k: truncate_to_unique, length=3
    # ─────────────────────────────────────────────────────────────────────────
    classic = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = "$cmd_duration";

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncate_to_repo = true;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = "[($virtualenv)]($style) ";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base03"}";
        format = "[$duration]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0D"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # PURE - sindresorhus/pure recreation
    # P10k: no truncation (full path), uses * for modified
    # ─────────────────────────────────────────────────────────────────────────
    pure = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncate_to_repo = false;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base04"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "*";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base0A"}";
        format = "[$duration]($style)";
        min_time = 5000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0E"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # POWERLINE - Filled segments with powerline arrows
    # P10k: truncate_to_last, length=2, segment separators
    # ─────────────────────────────────────────────────────────────────────────
    powerline = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "[](fg:${c "base0D"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base03"})"
        "$cmd_duration"
        "[](fg:${c "base03"})"
      ];

      directory = {
        style = "fg:${c "base01"} bg:${c "base0D"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base01"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base01"} bg:${c "base0B"}";
        format = "[$staged$modified$untracked$ahead_behind ]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base06"} bg:${c "base03"}";
        format = "[ $duration ]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # DEVELOPER - Shows language versions (node, go, rust, python, kube)
    # P10k: truncate_to_unique, length=3, shows versions in left prompt
    # ─────────────────────────────────────────────────────────────────────────
    developer = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$nodejs"
        "$golang"
        "$rust"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$cmd_duration"
        "$kubernetes"
      ];

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 3;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = "[($virtualenv)]($style) ";
        detect_extensions = [];
        detect_files = [];
      };

      nodejs = {
        style = "fg:${c "base0B"}";
        format = "[ $version]($style) ";
      };

      golang = {
        style = "fg:${c "base0C"}";
        format = "[󰟓 $version]($style) ";
      };

      rust = {
        style = "fg:${c "base09"}";
        format = "[ $version]($style) ";
      };

      kubernetes = {
        style = "fg:${c "base0D"}";
        format = "[☸ $context]($style) ";
        disabled = false;
      };

      cmd_duration = {
        style = "fg:${c "base03"}";
        format = "[$duration]($style) ";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # UNIX - Classic user@host ~/nix  branch+! λ
    # P10k: truncate_to_last, length=2, user@host prefix
    # ─────────────────────────────────────────────────────────────────────────
    unix = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "[@](fg:${c "base05"})"
        "$hostname"
        " "
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      username = {
        style_user = "fg:${c "base0B"}";
        style_root = "fg:${c "base08"}";
        format = "[$user]($style_user)";
        show_always = true;
      };

      hostname = {
        style = "fg:${c "base0C"}";
        format = "[$hostname]($style)";
        ssh_only = false;
      };

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 2;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0E"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # MINIMAL - Ultra-minimal: ~ λ
    # P10k: truncate_to_last, length=1, no git
    # ─────────────────────────────────────────────────────────────────────────
    minimal = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$character"
      ];

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 1;
        truncate_to_repo = false;
        home_symbol = "~";
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # BOXED - ASCII box frame: ┌─ user in ~/nix on  main+! └─λ
    # P10k: truncate_to_unique, length=3, "in" prefix, "on" before git
    # ─────────────────────────────────────────────────────────────────────────
    boxed = {
      add_newline = true;
      format = lib.concatStrings [
        "[┌─](fg:${c "base04"}) "
        "$username"
        "[ in](fg:${c "base04"}) "
        "$directory"
        "[ on](fg:${c "base04"})"
        "$git_branch"
        "$git_status"
        "$python"
        "$cmd_duration"
        "$line_break"
        "[└─](fg:${c "base04"})"
        "$character"
      ];

      username = {
        style_user = "fg:${c "base0E"}";
        style_root = "fg:${c "base08"}";
        format = "[$user]($style_user)";
        show_always = true;
      };

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style)";
        truncation_length = 3;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = " [ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0C"}";
        format = "[ via $virtualenv]($style)";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base0A"}";
        format = " [$duration]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # CAPSULE - Rounded pill/capsule segments (powerline style)
    # P10k: truncate_to_last, length=2, rounded segment separators
    # ─────────────────────────────────────────────────────────────────────────
    capsule = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "[](fg:${c "base0C"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base02"})"
        "$cmd_duration"
        "[](fg:${c "base02"})"
      ];

      directory = {
        style = "fg:${c "base00"} bg:${c "base0C"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[$staged$modified$untracked$ahead_behind ]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = " [](fg:${c "base0E"})[ $virtualenv ](fg:${c "base00"} bg:${c "base0E"})[](fg:${c "base0E"})";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base05"} bg:${c "base02"}";
        format = "[ $duration ]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SLANTED - Slanted powerline separators
    # P10k: truncate_to_last, length=2, slanted segment separators
    # ─────────────────────────────────────────────────────────────────────────
    slanted = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "[](fg:${c "base0D"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base03"})"
        "$cmd_duration"
        "[](fg:${c "base03"})"
      ];

      directory = {
        style = "fg:${c "base00"} bg:${c "base0D"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[$staged$modified$untracked$ahead_behind ]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = " [](fg:${c "base0E"})[ $virtualenv ](fg:${c "base00"} bg:${c "base0E"})[](fg:${c "base0E"})";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base06"} bg:${c "base03"}";
        format = "[ $duration ]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # STARSHIP - Use Starship's beautiful default with Base16 colors
    # Uses $all format for full-featured prompt with all modules
    # ─────────────────────────────────────────────────────────────────────────
    starship = {
      add_newline = true;
      # Use $all to get Starship's full default modules (gcloud, cmd_duration, etc.)
      format = "$all";

      # Directory styling
      directory = {
        style = "fg:${c "base0C"}";  # Cyan for directory
        truncation_length = 3;
        truncate_to_repo = true;
      };

      # Git branch
      git_branch = {
        style = "fg:${c "base0E"}";  # Purple for branch
      };

      # Git status
      git_status = {
        style = "fg:${c "base0A"}";  # Yellow for status
      };

      # Character prompt (❯ instead of λ to match default)
      character = {
        success_symbol = "[❯](fg:${c "base0B"})";
        error_symbol = "[❯](fg:${c "base08"})";
      };

      # Cloud providers
      gcloud = {
        style = "fg:${c "base0D"}";  # Blue for gcloud
        format = "on [$symbol$account(@$domain)]($style) ";
      };

      aws = {
        style = "fg:${c "base09"}";  # Orange for AWS
      };

      # Command duration
      cmd_duration = {
        style = "fg:${c "base0A"}";
        min_time = 2000;
      };

      # Language versions - subtle styling
      nodejs = {
        style = "fg:${c "base0B"}";  # Green
      };

      python = {
        style = "fg:${c "base0A"}";  # Yellow
      };

      golang = {
        style = "fg:${c "base0C"}";  # Cyan
      };

      rust = {
        style = "fg:${c "base09"}";  # Orange
      };

      # Kubernetes
      kubernetes = {
        style = "fg:${c "base0D"}";
        disabled = false;
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # HACKER - Matrix/cyberpunk green aesthetic
    # P10k: truncate_to_last, length=1, ▶ prefix, :: separator
    # ─────────────────────────────────────────────────────────────────────────
    hacker = {
      add_newline = true;
      format = lib.concatStrings [
        "[▶](fg:${c "base0B"}) "
        "$directory"
        "[::](fg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      right_format = "$cmd_duration";

      directory = {
        style = "fg:${c "base0B"}";
        format = "[$path]($style)";
        truncation_length = 1;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0C"}";
        format = " [$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base0C"}";
        format = "[$duration]($style)";
        min_time = 2000;
        show_milliseconds = true;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # ARROW - Clean arrow-based: user@host:~/nix  branch+! λ
    # P10k: truncate_to_last, length=3, user@host: prefix
    # ─────────────────────────────────────────────────────────────────────────
    arrow = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "[@](fg:${c "base05"})"
        "$hostname"
        "[:]($style)"
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      username = {
        style_user = "fg:${c "base0B"}";
        style_root = "fg:${c "base08"}";
        format = "[$user]($style_user)";
        show_always = true;
      };

      hostname = {
        style = "fg:${c "base0C"}";
        format = "[$hostname]($style)";
        ssh_only = false;
      };

      directory = {
        style = "fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 3;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SOFT - Catppuccin-inspired soft aesthetic with diamond prefix
    # P10k: truncate_to_unique, length=3, ◆ prefix
    # ─────────────────────────────────────────────────────────────────────────
    soft = {
      add_newline = true;
      format = lib.concatStrings [
        "[◆](fg:${c "base0E"}) "
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = "$cmd_duration";

      directory = {
        style = "fg:${c "base0E"}";
        format = "[$path]($style) ";
        truncation_length = 3;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$staged$modified$untracked$ahead_behind]($style) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0C"}";
        format = "[$virtualenv]($style) ";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base04"}";
        format = "[$duration]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0E"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # RAINBOW - Colorful segments with distinct backgrounds
    # P10k: truncate_to_last, length=2, colorful segment separators
    # ─────────────────────────────────────────────────────────────────────────
    rainbow = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "[](fg:${c "base0C"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base02"})"
        "$cmd_duration"
        "[](fg:${c "base02"})"
      ];

      directory = {
        style = "fg:${c "base00"} bg:${c "base0C"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
        home_symbol = "~";
      };

      git_branch = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base00"} bg:${c "base0B"}";
        format = "[$staged$modified$untracked$ahead_behind ]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = " [](fg:${c "base0E"})[ $virtualenv ](fg:${c "base00"} bg:${c "base0E"})[](fg:${c "base0E"})";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base06"} bg:${c "base02"}";
        format = "[ $duration ]($style)";
        min_time = 3000;
      };

      character = {
        success_symbol = "[λ](fg:${c "base0B"})";
        error_symbol = "[λ](fg:${c "base08"})";
      };
    };
  };

  # Select the appropriate style
  selectedStyle = starshipStyles.${promptStyle};

in {
  # Always have starship package available (prevents "no such file" errors)
  # but only enable zsh integration when it's the selected engine
  programs.starship = {
    enable = true;
    # Only integrate with zsh when starship is the selected engine
    enableZshIntegration = (promptEngine == "starship");
    # Only set custom settings when starship is the engine
    settings = lib.mkIf (promptEngine == "starship") selectedStyle;
  };
}
