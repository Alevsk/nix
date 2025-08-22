# Dracula theme configuration for p10k
{
  name = "dracula";
  description = "Popular dark theme with purple accents";
  
  # Powerlevel10k configuration
  p10k = {
    # Left prompt elements
    left_prompt_elements = [
      "os_icon"
      "dir"
      "vcs"
    ];
    
    # Right prompt elements  
    right_prompt_elements = [
      "status"
      "command_execution_time"
      "background_jobs"
      "battery"
      "time"
    ];
    
    # Colors - Dracula palette
    colors = {
      dir_foreground = "15";
      dir_background = "61";   # Purple
      vcs_clean_foreground = "0";
      vcs_clean_background = "84";  # Green
      vcs_dirty_foreground = "0";
      vcs_dirty_background = "215"; # Orange
      time_foreground = "117"; # Light purple
      os_icon_foreground = "15";
      os_icon_background = "212";
    };
    
    # Icons
    icons = {
      left_segment_separator = "";
      right_segment_separator = "";
      left_subsegment_separator = "";
      right_subsegment_separator = "";
    };
  };
  
  # Alacritty color scheme - Dracula
  alacritty_colors = {
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
}
