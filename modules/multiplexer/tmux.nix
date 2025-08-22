{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
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
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Enable mouse support
      set -g mouse on
      
      # Status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-left '[#S] '
      set -g status-right '%Y-%m-%d %H:%M'
    '';
  };
}
