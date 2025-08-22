# Cyberpunk theme configuration
{
  name = "cyberpunk";
  description = "Neon cyberpunk theme with bright colors";
  
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
      "time"
    ];
    
    # Colors - Neon cyberpunk palette
    colors = {
      dir_foreground = "0";
      dir_background = "13";  # Bright magenta
      vcs_clean_foreground = "0";
      vcs_clean_background = "10";  # Bright green
      vcs_dirty_foreground = "0";
      vcs_dirty_background = "11";  # Bright yellow
      time_foreground = "14";  # Bright cyan
    };
    
    # Icons
    icons = {
      left_segment_separator = "";
      right_segment_separator = "";
      left_subsegment_separator = "";
      right_subsegment_separator = "";
    };
  };
  
  # Alacritty color scheme - Cyberpunk neon
  alacritty_colors = {
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
}
