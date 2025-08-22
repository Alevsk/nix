# Default theme configuration
{
  name = "default";
  description = "Clean and minimal theme";
  
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
    
    # Colors - Default palette
    colors = {
      dir_foreground = "31";
      dir_background = "237";
      vcs_clean_foreground = "76";
      vcs_clean_background = "237";
      vcs_dirty_foreground = "178";
      vcs_dirty_background = "237";
      time_foreground = "66";
    };
    
    # Icons
    icons = {
      left_segment_separator = "";
      right_segment_separator = "";
      left_subsegment_separator = "";
      right_subsegment_separator = "";
    };
  };
  
  # Alacritty color scheme
  alacritty_colors = {
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
}
