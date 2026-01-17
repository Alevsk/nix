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
  # STARSHIP PROMPT STYLES - 15 Distinct r/unixporn-worthy designs
  # Each style has a unique visual identity and purpose
  # ═══════════════════════════════════════════════════════════════════════════

  starshipStyles = {
    # ─────────────────────────────────────────────────────────────────────────
    # MINIMAL - "Negative Space"
    # The absolute minimum. Just breathe.
    # Format: ~ ›
    # ─────────────────────────────────────────────────────────────────────────
    minimal = {
      add_newline = false;
      format = "$directory$character";

      directory = {
        style = "fg:${c "base05"}";
        format = "[$path]($style) ";
        truncation_length = 1;
        truncate_to_repo = false;
      };

      character = {
        success_symbol = "[›](fg:${c "base04"})";
        error_symbol = "[›](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # LEAN - "Zen Single-Line"
    # Everything you need, nothing you don't.
    # Format: nix main ❯
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
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 1;
        truncate_to_repo = false;
      };

      git_branch = {
        style = "fg:${c "base0E"}";
        format = "[$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base09"}";
        format = "[$all_status]($style) ";
        modified = "*";
        staged = "+";
        untracked = "?";
        conflicted = "!";
        ahead = "↑";
        behind = "↓";
        diverged = "↕";
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # PURE - Exact sindresorhus/pure recreation
    # The original minimal async prompt
    # Format: ~/nix main *
    #         ❯
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
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncate_to_repo = false;
      };

      git_branch = {
        style = "fg:${c "base04"}";
        format = "[$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$all_status$ahead_behind]($style) ";
        modified = "*";
        staged = "";
        untracked = "";
        stashed = "≡";
        ahead = "↑";
        behind = "↓";
      };

      cmd_duration = {
        style = "fg:${c "base0A"}";
        format = "[$duration]($style)";
        min_time = 5000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0E"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # CLASSIC - "Refined Two-Line"
    # Balanced, informative, elegant
    # Format: ~/nix  main (venv)
    #         ❯
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
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base0A"}";
        format = "([$all_status$ahead_behind]($style)) ";
        modified = "!";
        staged = "+";
        untracked = "?";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = "[\\($virtualenv\\)]($style) ";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base04"}";
        format = "[$duration]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0E"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # POWERLINE - "Solid Segments"
    # Classic powerline with arrow separators
    # Format:  ~/nix   main
    #         ❯
    # ─────────────────────────────────────────────────────────────────────────
    powerline = {
      add_newline = true;
      format = lib.concatStrings [
        "[](fg:${c "base0D"})"
        "$directory"
        "[](fg:${c "base0D"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base02"})"
        "$cmd_duration"
        "[](fg:${c "base02"})"
      ];

      directory = {
        style = "bold fg:${c "base00"} bg:${c "base0D"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
      };

      git_branch = {
        style = "bold fg:${c "base00"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base00"} bg:${c "base0B"}";
        format = "[ $all_status]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base05"} bg:${c "base02"}";
        format = "[ $duration ]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # CAPSULE - "Rounded Pills"
    # True capsule segments with rounded ends
    # Format:  ~/nix   main
    #         ❯
    # ─────────────────────────────────────────────────────────────────────────
    capsule = {
      add_newline = true;
      format = lib.concatStrings [
        "[](fg:${c "base0C"})"
        "$directory"
        "[](fg:${c "base0C"} bg:${c "base0B"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0B"})"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base02"})"
        "$cmd_duration"
        "[](fg:${c "base02"})"
      ];

      directory = {
        style = "bold fg:${c "base00"} bg:${c "base0C"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
      };

      git_branch = {
        style = "bold fg:${c "base00"} bg:${c "base0B"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base00"} bg:${c "base0B"}";
        format = "[ $all_status]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = " [](fg:${c "base0E"})[$virtualenv](bold fg:${c "base00"} bg:${c "base0E"})[](fg:${c "base0E"})";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base05"} bg:${c "base02"}";
        format = "[ $duration ]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SLANTED - "Sharp Angles"
    # Modern slanted separators for a dynamic look
    # Format:  ~/nix   main
    #         ❯
    # ─────────────────────────────────────────────────────────────────────────
    slanted = {
      add_newline = true;
      format = lib.concatStrings [
        "[](fg:${c "base0D"})"
        "$directory"
        "[](fg:${c "base0D"} bg:${c "base0E"})"
        "$git_branch"
        "$git_status"
        "[](fg:${c "base0E"})"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base03"})"
        "$cmd_duration"
        "[](fg:${c "base03"})"
      ];

      directory = {
        style = "bold fg:${c "base00"} bg:${c "base0D"}";
        format = "[ $path ]($style)";
        truncation_length = 2;
      };

      git_branch = {
        style = "bold fg:${c "base00"} bg:${c "base0E"}";
        format = "[  $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base00"} bg:${c "base0E"}";
        format = "[ $all_status]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base06"} bg:${c "base03"}";
        format = "[ $duration ]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0E"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # RAINBOW - "Color Gradient"
    # True rainbow: each segment a different color in spectrum order
    # Format:  ~   nix   main
    #         ❯
    # ─────────────────────────────────────────────────────────────────────────
    rainbow = {
      add_newline = true;
      format = lib.concatStrings [
        # Magenta start
        "[](fg:${c "base0E"})"
        "$username"
        "[](fg:${c "base0E"} bg:${c "base0D"})"
        # Blue
        "$directory"
        "[](fg:${c "base0D"} bg:${c "base0C"})"
        # Cyan
        "$git_branch"
        "[](fg:${c "base0C"} bg:${c "base0B"})"
        # Green
        "$git_status"
        "[](fg:${c "base0B"})"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:${c "base09"})"
        "$cmd_duration"
        "[](fg:${c "base09"})"
      ];

      username = {
        style_user = "bold fg:${c "base00"} bg:${c "base0E"}";
        format = "[ $user ]($style)";
        show_always = true;
      };

      directory = {
        style = "bold fg:${c "base00"} bg:${c "base0D"}";
        format = "[ $path ]($style)";
        truncation_length = 1;
      };

      git_branch = {
        style = "bold fg:${c "base00"} bg:${c "base0C"}";
        format = "[  $branch ]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base00"} bg:${c "base0B"}";
        format = "[ $all_status ]($style)";
        modified = "~";
        staged = "+";
        untracked = "•";
      };

      cmd_duration = {
        style = "bold fg:${c "base00"} bg:${c "base09"}";
        format = "[ $duration ]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # HACKER - "Terminal Operator"
    # Clean, dense, professional. Not cliché green.
    # Format: [nix:main*] ▸
    # ─────────────────────────────────────────────────────────────────────────
    hacker = {
      add_newline = false;
      format = lib.concatStrings [
        "[\\[](fg:${c "base04"})"
        "$directory"
        "$git_branch"
        "$git_status"
        "[\\]](fg:${c "base04"}) "
        "$character"
      ];

      right_format = "$cmd_duration";

      directory = {
        style = "fg:${c "base0C"}";
        format = "[$path]($style)";
        truncation_length = 1;
      };

      git_branch = {
        style = "fg:${c "base0E"}";
        format = "[:$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base09"}";
        format = "[$all_status]($style)";
        modified = "*";
        staged = "+";
        untracked = "?";
      };

      cmd_duration = {
        style = "fg:${c "base04"}";
        format = "[$duration]($style)";
        min_time = 1000;
        show_milliseconds = true;
      };

      character = {
        success_symbol = "[▸](fg:${c "base0C"})";
        error_symbol = "[▸](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # BOXED - "Framed"
    # Elegant box drawing, clear visual hierarchy
    # Format: ╭─ ~/nix on  main
    #         ╰─ ❯
    # ─────────────────────────────────────────────────────────────────────────
    boxed = {
      add_newline = true;
      format = lib.concatStrings [
        "[╭─](fg:${c "base04"}) "
        "$directory"
        "$git_branch"
        "$git_status"
        "$python"
        "$cmd_duration"
        "$line_break"
        "[╰─](fg:${c "base04"}) "
        "$character"
      ];

      directory = {
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style)";
        truncation_length = 3;
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = " [on](fg:${c "base04"})  [$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base0A"}";
        format = " [$all_status$ahead_behind]($style)";
        modified = "!";
        staged = "+";
        untracked = "?";
        ahead = "⇡";
        behind = "⇣";
      };

      python = {
        style = "fg:${c "base0E"}";
        format = " [via](fg:${c "base04"}) [ $virtualenv]($style)";
        detect_extensions = [];
        detect_files = [];
      };

      cmd_duration = {
        style = "fg:${c "base04"}";
        format = " [took](fg:${c "base04"}) [$duration]($style)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # DEVELOPER - "IDE Status Bar"
    # Info-rich but organized, for polyglot developers
    # Format: ~/nix  main   v22  v1.21
    #         λ
    # ─────────────────────────────────────────────────────────────────────────
    developer = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$golang"
        "$rust"
        "$python"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$cmd_duration"
        "$kubernetes"
      ];

      directory = {
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 3;
      };

      git_branch = {
        style = "fg:${c "base0E"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "bold fg:${c "base0A"}";
        format = "([$all_status$ahead_behind]($style)) ";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      nodejs = {
        style = "fg:${c "base0B"}";
        format = "[ $version]($style) ";
      };

      golang = {
        style = "fg:${c "base0C"}";
        format = "[ $version]($style) ";
      };

      rust = {
        style = "fg:${c "base09"}";
        format = "[ $version]($style) ";
      };

      python = {
        style = "fg:${c "base0A"}";
        format = "[ $version]($style) ";
      };

      kubernetes = {
        style = "fg:${c "base0D"}";
        format = "[☸ $context]($style) ";
        disabled = false;
      };

      cmd_duration = {
        style = "fg:${c "base04"}";
        format = "[$duration]($style) ";
        min_time = 2000;
      };

      character = {
        success_symbol = "[λ](bold fg:${c "base0B"})";
        error_symbol = "[λ](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # UNIX - "Classic Shell"
    # Traditional PS1 style, no fancy glyphs
    # Format: user@host:~/nix$
    # ─────────────────────────────────────────────────────────────────────────
    unix = {
      add_newline = false;
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
        style_root = "bold fg:${c "base08"}";
        format = "[$user]($style_user)";
        show_always = true;
      };

      hostname = {
        style = "fg:${c "base0C"}";
        format = "[$hostname]($style)";
        ssh_only = false;
      };

      directory = {
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style)";
        truncation_length = 3;
      };

      git_branch = {
        style = "fg:${c "base0E"}";
        format = " ($branch)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$all_status]($style)";
        modified = "*";
        staged = "+";
        untracked = "?";
      };

      character = {
        success_symbol = "[\\$](fg:${c "base05"})";
        error_symbol = "[\\$](bold fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # STARSHIP - "Official Starship Look"
    # Matches the default Starship aesthetic
    # Format: nix on  main via  v22 ❯
    # ─────────────────────────────────────────────────────────────────────────
    starship = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$python"
        "$golang"
        "$rust"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "bold fg:${c "base0C"}";
        truncation_length = 1;
        truncate_to_repo = false;
      };

      git_branch = {
        style = "bold fg:${c "base0E"}";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold fg:${c "base08"}";
        format = "([$all_status$ahead_behind]($style) )";
      };

      nodejs = {
        style = "fg:${c "base0B"}";
        format = "via [ $version]($style) ";
      };

      python = {
        style = "fg:${c "base0A"}";
        format = "via [ $version]($style) ";
      };

      golang = {
        style = "fg:${c "base0C"}";
        format = "via [ $version]($style) ";
      };

      rust = {
        style = "fg:${c "base09"}";
        format = "via [ $version]($style) ";
      };

      cmd_duration = {
        style = "fg:${c "base0A"}";
        format = "took [$duration]($style) ";
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](bold fg:${c "base0B"})";
        error_symbol = "[❯](bold fg:${c "base08"})";
      };

      # Disable noisy modules
      kubernetes.disabled = true;
      package.disabled = true;
      gcloud.disabled = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SOFT - "Pastel Dreams"
    # Catppuccin-inspired soft aesthetic
    # Format: ● ~/nix  main
    #         ❯
    # ─────────────────────────────────────────────────────────────────────────
    soft = {
      add_newline = true;
      format = lib.concatStrings [
        "[●](fg:${c "base0E"}) "
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
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[ $branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "([$all_status$ahead_behind]($style)) ";
        modified = "~";
        staged = "+";
        untracked = "•";
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
        min_time = 2000;
      };

      character = {
        success_symbol = "[❯](fg:${c "base0E"})";
        error_symbol = "[❯](fg:${c "base08"})";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # ARROW - "Flow State"
    # Arrow-based visual flow, clean and directional
    # Format: alevsk → nix → main →
    # ─────────────────────────────────────────────────────────────────────────
    arrow = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "[→](fg:${c "base04"}) "
        "$directory"
        "[→](fg:${c "base04"}) "
        "$git_branch"
        "$git_status"
        "$character"
      ];

      username = {
        style_user = "bold fg:${c "base0E"}";
        format = "[$user]($style_user) ";
        show_always = true;
      };

      directory = {
        style = "bold fg:${c "base0D"}";
        format = "[$path]($style) ";
        truncation_length = 1;
      };

      git_branch = {
        style = "fg:${c "base0B"}";
        format = "[$branch]($style)";
        symbol = "";
      };

      git_status = {
        style = "fg:${c "base0A"}";
        format = "[$all_status]($style) ";
        modified = "*";
        staged = "+";
        untracked = "?";
      };

      character = {
        success_symbol = "[→](bold fg:${c "base0B"})";
        error_symbol = "[→](bold fg:${c "base08"})";
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
    # Apply settings - they're only used when zsh integration is enabled anyway
    settings = selectedStyle;
  };
}
