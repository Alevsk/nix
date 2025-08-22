# Simple theme switcher for terminal themes
# To switch themes, change the "currentTheme" value below and rebuild

{ config, pkgs, ... }:

let
  # Available themes - change "currentTheme" to switch
  currentTheme = "catppuccin"; # Options: "catppuccin", "dracula", "cyberpunk", "ocean"
  
  themes = {
    catppuccin = {
      name = "Catppuccin Mocha";
      alacritty = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
      };
      p10k = {
        dir_fg = "31";
        dir_bg = "237";
        vcs_clean_fg = "76";
        vcs_dirty_fg = "178";
        separators = "powerline";
      };
    };
    
    dracula = {
      name = "Dracula";
      alacritty = {
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
        cursor = {
          text = "#282a36";
          cursor = "#f8f8f2";
        };
        normal = {
          black = "#000000";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#bd93f9";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#bfbfbf";
        };
        bright = {
          black = "#4d4d4d";
          red = "#ff6e67";
          green = "#5af78e";
          yellow = "#f4f99d";
          blue = "#caa9fa";
          magenta = "#ff92d0";
          cyan = "#9aedfe";
          white = "#e6e6e6";
        };
      };
      p10k = {
        dir_fg = "15";
        dir_bg = "61";
        vcs_clean_fg = "0";
        vcs_dirty_fg = "0";
        separators = "powerline";
      };
    };
    
    cyberpunk = {
      name = "Cyberpunk";
      alacritty = {
        primary = {
          background = "#0a0e27";
          foreground = "#00ff41";
        };
        cursor = {
          text = "#0a0e27";
          cursor = "#ff0080";
        };
        normal = {
          black = "#000000";
          red = "#ff0040";
          green = "#00ff41";
          yellow = "#ffff00";
          blue = "#0080ff";
          magenta = "#ff0080";
          cyan = "#00ffff";
          white = "#ffffff";
        };
        bright = {
          black = "#808080";
          red = "#ff4080";
          green = "#40ff80";
          yellow = "#ffff80";
          blue = "#4080ff";
          magenta = "#ff40c0";
          cyan = "#40ffff";
          white = "#ffffff";
        };
      };
      p10k = {
        dir_fg = "0";
        dir_bg = "13";
        vcs_clean_fg = "0";
        vcs_dirty_fg = "0";
        separators = "sharp";
      };
    };
    
    ocean = {
      name = "Ocean";
      alacritty = {
        primary = {
          background = "#0f1419";
          foreground = "#b3b1ad";
        };
        cursor = {
          text = "#0f1419";
          cursor = "#ffcc66";
        };
        normal = {
          black = "#01060e";
          red = "#ea6c73";
          green = "#91b362";
          yellow = "#f9af4f";
          blue = "#53bdfa";
          magenta = "#fae994";
          cyan = "#90e1c6";
          white = "#c7c7c7";
        };
        bright = {
          black = "#686868";
          red = "#f07178";
          green = "#c2d94c";
          yellow = "#ffb454";
          blue = "#59c2ff";
          magenta = "#ffee99";
          cyan = "#95e6cb";
          white = "#ffffff";
        };
      };
      p10k = {
        dir_fg = "15";
        dir_bg = "24";
        vcs_clean_fg = "15";
        vcs_dirty_fg = "15";
        separators = "round";
      };
    };
  };
  
  selectedTheme = themes.${currentTheme};
  
in {
  # Export theme data for other modules
  _module.args.terminalTheme = selectedTheme;
  
  # Create theme info file
  home.file.".current-theme" = {
    text = ''
      Current Theme: ${selectedTheme.name}
      
      To switch themes:
      1. Edit ~/nix/modules/terminal/themes/theme-switcher.nix
      2. Change currentTheme = "${currentTheme}" to one of:
         - "catppuccin" (default dark theme)
         - "dracula" (purple accents)
         - "cyberpunk" (neon colors)
         - "ocean" (blue/teal theme)
      3. Run: home-manager switch --flake ~/nix#alevsk
      4. Restart your terminal
    '';
  };
}
