# Ocean theme configuration
{
  name = "ocean";
  description = "Calm ocean blues and teals";
  
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
    
    # Colors - Ocean palette
    colors = {
      dir_foreground = "15";
      dir_background = "24";   # Deep blue
      vcs_clean_foreground = "15";
      vcs_clean_background = "30";  # Teal
      vcs_dirty_foreground = "15";
      vcs_dirty_background = "166"; # Orange
      time_foreground = "81";  # Light blue
    };
    
    # Icons
    icons = {
      left_segment_separator = "";
      right_segment_separator = "";
      left_subsegment_separator = "";
      right_subsegment_separator = "";
    };
  };
  
  # Alacritty color scheme - Ocean theme
  alacritty_colors = {
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
}
