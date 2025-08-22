{ config, pkgs, terminalTheme, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
      
      # Fix input lag and character duplication
      keyboard = {
        bindings = [];
      };
      
      # General settings
      general = {
        live_config_reload = false;
      };
      
      # Terminal settings to prevent input issues
      env = {
        TERM = "xterm-256color";
        TERM_PROGRAM = "Alacritty";
      };
      
      # Debug settings to help with input issues
      debug = {
        render_timer = false;
        persistent_logging = false;
        log_level = "Warn";
        print_events = false;
      };
      
      # Scrolling and input settings
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      
      # Mouse settings
      mouse = {
        hide_when_typing = true;
      };
      
      # Selection settings
      selection = {
        save_to_clipboard = true;
      };
      
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 14.0;
      };
      
      # Dynamic theme colors from themes/ folder
      colors = terminalTheme.alacritty_colors;
    };
  };
}
