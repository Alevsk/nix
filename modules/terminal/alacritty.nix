{ config, pkgs, lib, ... }:

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
        # Send ESC prefix for Alt/Meta so tmux/apps receive M- keys
        alt_send_esc = true;
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
      
      # Font configuration for Powerlevel10k
      font = {
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
          style = "Bold Italic";
        };
        size = lib.mkForce 14;
      };
      
      # Mouse settings
      mouse = {
        hide_when_typing = true;
      };
      
      # Selection settings
      selection = {
        save_to_clipboard = true;
      };
    };
  };
}
