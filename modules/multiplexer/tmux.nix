{
  config,
  pkgs,
  tmuxTintScheme ? "base16-nord",
  ...
}: let
  gawk = "${pkgs.gawk}/bin/gawk";

  # Script to get CPU usage, now with absolute paths.
  tmux-cpu-script = pkgs.writeShellScriptBin "tmux-cpu" ''
    #!${pkgs.stdenv.shell}
    /usr/bin/top -l 1 | /usr/bin/grep 'CPU usage' | ${gawk} '{sub(/%/, "", $7); printf "%.0f%%", 100 - $7}'
  '';

  # Script to get Memory usage, now with absolute paths.
  tmux-mem-script = pkgs.writeShellScriptBin "tmux-mem" ''
    #!${pkgs.stdenv.shell}
    /usr/bin/memory_pressure -Q 2>/dev/null | ${gawk} '/System-wide memory free percentage/ {sub(/%/, "", $5); printf "%d%%", 100 - $5}'
  '';

  # Script to get Battery status, now with absolute paths.
  tmux-batt-script = pkgs.writeShellScriptBin "tmux-batt" ''
    #!${pkgs.stdenv.shell}
    /usr/bin/pmset -g batt | ${gawk} '
      /InternalBattery/ {
        # Extract percentage using regex - matches "100%" pattern
        if (match($0, /([0-9]+)%/, arr)) {
          pct = arr[1]
        } else {
          pct = 0
        }

        # Determine charging state
        if (index($0, "charging") > 0) {
          bolt = " "
        } else {
          bolt = ""
        }

        # Select battery icon based on percentage
        if      (pct >= 80) { icon = "" }
        else if (pct >= 60) { icon = "" }
        else if (pct >= 40) { icon = "" }
        else if (pct >= 20) { icon = "" }
        else                { icon = "" }

        printf "%s%s%d%%", icon, bolt, pct
        exit
      }
    '
  '';

  # Script to get current IP address
  tmux-ip-script = pkgs.writeShellScriptBin "tmux-ip" ''
    #!${pkgs.stdenv.shell}
    ip addr show en0 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f 1
  '';

  # Define the left status bar as a Nix variable for readability.
  statusLeftString = pkgs.lib.strings.concatStrings [
    # --- Apple Logo and Hostname ---
    # We use #h for the short hostname. Use #H for the full one.
    # The icon  is the Apple logo in most Nerd Fonts.
    "#[fg=#${config.lib.stylix.colors.base0E},bold] " # Apple Logo
    "#[fg=#${config.lib.stylix.colors.base06}]#h " # Hostname
    "#[fg=#${config.lib.stylix.colors.base03}]│ " # Separator

    # --- Session Name ---
    # The 󰣇 icon is a nice symbol for tmux itself.
    "#[fg=#${config.lib.stylix.colors.base0D},bold]󰣇 " # Session Icon
    "#[fg=#${config.lib.stylix.colors.base06}]#S " # Session Name
    "#[fg=#${config.lib.stylix.colors.base03}]│ " # Separator

    # --- Window and Pane Counts ---
    "#[fg=#${config.lib.stylix.colors.base0A}] " # Window Icon
    "#[fg=#${config.lib.stylix.colors.base06}]#{session_windows} " # Window count
    "#[fg=#${config.lib.stylix.colors.base03}]• " # Dot Separator
    "#[fg=#${config.lib.stylix.colors.base0C}] " # Pane Icon
    "#[fg=#${config.lib.stylix.colors.base06}]#{window_panes} " # Pane count
    "#[fg=#${config.lib.stylix.colors.base03}]• " # Dot Separator

    # --- Current Working Directory ---
    "#[fg=#${config.lib.stylix.colors.base0B}] " # Folder Icon
    "#[fg=#${config.lib.stylix.colors.base06}]#{b:pane_current_path} " # Current path (basename only)
    "#[fg=#${config.lib.stylix.colors.base03}]│ " # Separator
  ];

  # Combine all parts of the status-right string
  statusRightString = pkgs.lib.strings.concatStrings [
    "#{?client_prefix,#[fg=#${config.lib.stylix.colors.base0E}]⌨ #[fg=#${config.lib.stylix.colors.base03}]│ ,}"
    "#{?window_zoomed_flag,#[fg=#${config.lib.stylix.colors.base0E}] Z #[fg=#${config.lib.stylix.colors.base03}]│ ,}"
    "#{?pane_in_mode,#[fg=#${config.lib.stylix.colors.base0E}]󰆐 COPY #[fg=#${config.lib.stylix.colors.base03}]│ ,}"
    "#{?pane_synchronized,#[fg=#${config.lib.stylix.colors.base0E}]󰒡 SYNC #[fg=#${config.lib.stylix.colors.base03}]│ ,}"
    "#[fg=#${config.lib.stylix.colors.base0A}]󰍛 #[fg=#${config.lib.stylix.colors.base06}]#(${tmux-cpu-script}/bin/tmux-cpu) "
    "#[fg=#${config.lib.stylix.colors.base03}]│ "
    "#[fg=#${config.lib.stylix.colors.base0D}]󰍛 #[fg=#${config.lib.stylix.colors.base06}]#(${tmux-mem-script}/bin/tmux-mem) "
    "#[fg=#${config.lib.stylix.colors.base03}]│ "
    "#[fg=#${config.lib.stylix.colors.base0B}]#(${tmux-batt-script}/bin/tmux-batt) "
    "#[fg=#${config.lib.stylix.colors.base03}]│ "
    "#[fg=#${config.lib.stylix.colors.base0B}]󰍛 #[fg=#${config.lib.stylix.colors.base06}]#(${tmux-ip-script}/bin/tmux-ip) "
    "#[fg=#${config.lib.stylix.colors.base03}]│ "
    "#[fg=#${config.lib.stylix.colors.base0B}]󰓢 #[fg=#${config.lib.stylix.colors.base06}]#{pane_current_command}"
    "#{?#{==:#{pane_current_command},ssh}, #[fg=#${config.lib.stylix.colors.base0D}]󰣀 SSH,}  "
  ];

  # Format for the currently active window.
  # Underlines the index for a clean, integrated look.
  windowCurrentFormat = pkgs.lib.strings.concatStrings [
    "#[fg=#${config.lib.stylix.colors.base0D},bold,underline] #I "
  ];

  # Format for inactive windows (no change needed).
  windowFormat = pkgs.lib.strings.concatStrings [
    "#[fg=#${config.lib.stylix.colors.base04}] #I "
  ];
in {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";

    extraConfig = ''
      # Prefix key
      unbind C-a
      set -g prefix C-b
      bind C-b send-prefix

      # Better splitting
      bind | split-window -h
      bind - split-window -v

      # Vim-like pane navigation
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # No-prefix navigation
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind -n S-Left select-pane -L
      bind -n S-Down select-pane -D
      bind -n S-Up select-pane -U
      bind -n S-Right select-pane -R

      # Enable mouse support
      set -g mouse on

      # Truecolor and key reliability inside tmux
      set -ga terminal-overrides ',xterm-256color:RGB,alacritty:RGB'
      set -sg escape-time 10

      # Modern status bar configuration
      set -g status on
      set -g status-interval 2
      set -g status-position bottom
      set -g status-justify left
      set -g status-left-length 100
      set -g status-right-length 150
      set -g status-keys vi
      set -g mode-keys vi

      # Status bar styling using Stylix colors
      set -g status-style "bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base05}"
      set -g message-style "bg=#${config.lib.stylix.colors.base02},fg=#${config.lib.stylix.colors.base05}"
      set -g message-command-style "bg=#${config.lib.stylix.colors.base02},fg=#${config.lib.stylix.colors.base05}"
      set -g mode-style "bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00}"

      # Pane borders (subtle) to avoid a hard line above status
      set -g pane-border-style "fg=#${config.lib.stylix.colors.base01}"
      set -g pane-active-border-style "fg=#${config.lib.stylix.colors.base02}"

      # Window list styling and formats
      # set -g window-status-separator "  "
      # set -g window-status-style "bg=default,fg=#${config.lib.stylix.colors.base05}"
      # set -g window-status-activity-style "bg=default,fg=#${config.lib.stylix.colors.base07}"
      # set -g window-status-format " #[fg=#${config.lib.stylix.colors.base04}]#I #[fg=#${config.lib.stylix.colors.base06}]#W "
      # set -g window-status-current-style "bg=default,fg=#${config.lib.stylix.colors.base0D},bold"
      # set -g window-status-current-format " #[fg=#${config.lib.stylix.colors.base0D}] #[fg=#${config.lib.stylix.colors.base07},bold]#I #[fg=#${config.lib.stylix.colors.base07},bold]#W #[nobold]"

      # --- Window List Styling ---

      # A modest separator to space out the numbers.
      set -g window-status-separator " "

      # Style for windows with activity.
      # Makes the number bold and gives it a notification color.
      set -g window-status-activity-style "fg=#${config.lib.stylix.colors.base0A},bold"

      # Base style for all windows (inactive).
      set -g window-status-style "fg=#${config.lib.stylix.colors.base05},bg=default"

      # Apply our ultra-minimalist formats.
      set -g window-status-format "${windowFormat}"
      set -g window-status-current-format "${windowCurrentFormat}"

      # Left: session + counts
      set -g status-left "${statusLeftString}"

      # Right: indicators + CPU + MEM + BAT + cmd (+SSH)
      set -g status-right "${statusRightString}"

      # Window notifications
      set -g monitor-activity on
      set -g visual-activity off
    '';

    plugins = [];
  };
}
