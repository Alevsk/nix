{ config, pkgs, tmuxTintScheme ? "base16-nord", ... }:

{
  programs.tmux = {
    enable = true;
    # Use modern terminfo for better key/truecolor support
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
      set -g status-interval 1
      set -g status-position bottom
      set -g status-justify left
      set -g status-left-length 50
      set -g status-right-length 150
      
      # Status bar styling using direct color interpolation
      # This sets the main background for the entire bar
      set -g status-style "bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base05}"
      set -g message-style "bg=#${config.lib.stylix.colors.base02},fg=#${config.lib.stylix.colors.base05}"
      set -g message-command-style "bg=#${config.lib.stylix.colors.base02},fg=#${config.lib.stylix.colors.base05}"
      set -g mode-style "bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00}"
      
      # Pane borders with elegant styling
      set -g pane-border-style "fg=#${config.lib.stylix.colors.base02}"
      set -g pane-active-border-style "fg=#${config.lib.stylix.colors.base0D}"
      
      # Window status styling
      # set -g window-status-style "bg=#${config.lib.stylix.colors.base00},fg=#${config.lib.stylix.colors.base04}"
      # set -g window-status-current-style "bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00},bold"
      # set -g window-status-activity-style "bg=#${config.lib.stylix.colors.base0A},fg=#${config.lib.stylix.colors.base00}"
      # set -g window-status-bell-style "bg=#${config.lib.stylix.colors.base08},fg=#${config.lib.stylix.colors.base00}"
      
      # --- CORRECTED PILL-SHAPED STATUS BAR ---

      # Define variables for the round corner characters for clarity
      set -g @pill_left_start ""
      set -g @pill_left_end " " # Add a space for margin
      set -g @pill_right_start " " # Add a space for margin
      set -g @pill_right_end ""

      # Left status: Session pill
      set -g status-left-length 100
      set -g status-left "#[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_start}#[bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00},bold] 👻 #S #[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_end}"

      # Separator to create space between session and window pills
      set -g window-status-separator ""

      # Window status format for non-active windows
      set -g window-status-format "#[fg=#${config.lib.stylix.colors.base04},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_start}#[bg=#${config.lib.stylix.colors.base04},fg=#${config.lib.stylix.colors.base00}] #I 󰖯 #W #[fg=#${config.lib.stylix.colors.base04},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_end}"
      
      # Window status format for the current, active window
      set -g window-status-current-format "#[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_start}#[bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00},bold] #I 󰖯 #W #[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_left_end}"

      # Right status: A series of pills for system info
      set -g status-right-length 150
      set -g status-right "" # Clear before appending
      
      # Clock Pill
      set -ga status-right "#[fg=#${config.lib.stylix.colors.base0B},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_start}#[bg=#${config.lib.stylix.colors.base0B},fg=#${config.lib.stylix.colors.base00}]  %H:%M #[fg=#${config.lib.stylix.colors.base0B},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_end}"
      
      # Date Pill
      set -ga status-right "#[fg=#${config.lib.stylix.colors.base0E},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_start}#[bg=#${config.lib.stylix.colors.base0E},fg=#${config.lib.stylix.colors.base00}] 󰃭 %d %b #[fg=#${config.lib.stylix.colors.base0E},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_end}"
      
      # Hostname Pill
      set -ga status-right "#[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_start}#[bg=#${config.lib.stylix.colors.base0D},fg=#${config.lib.stylix.colors.base00},bold] #h #[fg=#${config.lib.stylix.colors.base0D},bg=#${config.lib.stylix.colors.base00}]#{@pill_right_end}"

      # --- END OF STATUS BAR SECTION ---

      # Window notifications
      set -g monitor-activity on
      set -g visual-activity off
    '';

    # Enable tinted-tmux for additional theming when available (disabled for custom styling)
    plugins = [ ];
  };
}
