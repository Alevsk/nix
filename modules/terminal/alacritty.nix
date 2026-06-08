{
  config,
  pkgs,
  lib,
  ...
}: let
  c = base: "#${config.lib.stylix.colors.${base}}";
in {
  # Alacritty is installed via Homebrew cask (see modules/system/homebrew.nix).
  # Nix only manages the configuration file.
  xdg.configFile."alacritty/alacritty.toml".source = (pkgs.formats.toml {}).generate "alacritty.toml" {
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

    # Font configuration for Powerlevel10k
    font = {
      size = 14;
    };

    # Mouse settings
    mouse = {};

    # Selection settings
    selection = {
      save_to_clipboard = true;
    };

    # Theme colors from Stylix (base16)
    colors = {
      primary = {
        foreground = c "base05";
        background = c "base00";
        dim_foreground = c "base04";
      };

      normal = {
        black = c "base01";
        red = c "base08";
        green = c "base0B";
        yellow = c "base0A";
        blue = c "base0D";
        magenta = c "base0E";
        cyan = c "base0C";
        white = c "base06";
      };

      bright = {
        black = c "base03";
        red = c "base09";
        green = c "base0B";
        yellow = c "base0A";
        blue = c "base0D";
        magenta = c "base0E";
        cyan = c "base0C";
        white = c "base07";
      };

      cursor = {
        text = c "base00";
        cursor = c "base05";
      };

      vi_mode_cursor = {
        text = c "base00";
        cursor = c "base0E";
      };

      selection = {
        text = c "base05";
        background = c "base02";
      };

      search = {
        matches = {
          foreground = c "base00";
          background = c "base0A";
        };
        focused_match = {
          foreground = c "base00";
          background = c "base09";
        };
      };
    };
  };
}
