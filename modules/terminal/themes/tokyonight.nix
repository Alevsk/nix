# Tokyo Night theme configuration
{
  name = "Tokyo Night";
  description = "Dark theme inspired by Tokyo's neon lights";
  
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
    
    # Colors - Tokyo Night palette
    colors = {
      dir_foreground = "15";
      dir_background = "57";  # Purple
      vcs_clean_foreground = "15";
      vcs_clean_background = "33";  # Blue
      vcs_dirty_foreground = "0";
      vcs_dirty_background = "214"; # Orange
      time_foreground = "147";  # Light purple
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
      background = "#1a1b26";
      foreground = "#c0caf5";
    };
    
    cursor = {
      text = "#1a1b26";
      cursor = "#c0caf5";
    };
    
    normal = {
      black = "#15161e";
      red = "#f7768e";
      green = "#9ece6a";
      yellow = "#e0af68";
      blue = "#7aa2f7";
      magenta = "#bb9af7";
      cyan = "#7dcfff";
      white = "#a9b1d6";
    };
    
    bright = {
      black = "#414868";
      red = "#f7768e";
      green = "#9ece6a";
      yellow = "#e0af68";
      blue = "#7aa2f7";
      magenta = "#bb9af7";
      cyan = "#7dcfff";
      white = "#c0caf5";
    };
  };
}
