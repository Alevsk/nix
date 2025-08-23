{ config, pkgs, tmuxTintScheme ? "base16-nord", ... }:

{
  programs.tmux = {
    enable = true;
    # Use modern terminfo for better key/truecolor support
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    
    extraConfig = ''
      # Better prefix key
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
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
      # Lower the ESC delay so Meta/Alt feels responsive
      set -sg escape-time 10
      
      # Status bar and pane styles (fallback when tinted-tmux is unavailable)
      set -g status-style "bg=#${config.lib.stylix.colors.base01},fg=#${config.lib.stylix.colors.base05}"
      set -g message-style "bg=#${config.lib.stylix.colors.base01},fg=#${config.lib.stylix.colors.base05}"
      set -g mode-style "bg=#${config.lib.stylix.colors.base02},fg=#${config.lib.stylix.colors.base06}"
      # Pane borders styled from Stylix colors
      set -g pane-border-style "fg=#${config.lib.stylix.colors.base03}"
      set -g pane-active-border-style "fg=#${config.lib.stylix.colors.base0D}"
      set -g status-left '[#S] '
      set -g status-right '%Y-%m-%d %H:%M'
    '';

    # Enable tinted-tmux for status bar theming when available
    plugins = (if pkgs.tmuxPlugins ? tinted-tmux then [
      {
        plugin = pkgs.tmuxPlugins.tinted-tmux;
        extraConfig = ''
          # Match current theme automatically (from home.nix mapping)
          set -g @tinted-tmux '${tmuxTintScheme}'
        '';
      }
    ] else [ ]);
  };
}
