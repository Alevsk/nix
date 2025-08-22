# Nord theme configuration
{
  name = "Nord";
  description = "Arctic, north-bluish color palette";
  
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
    
    # Colors - Nord palette
    colors = {
      dir_foreground = "15";
      dir_background = "67";   # Nord blue
      vcs_clean_foreground = "0";
      vcs_clean_background = "108"; # Nord green
      vcs_dirty_foreground = "0";
      vcs_dirty_background = "180"; # Nord yellow
      time_foreground = "109"; # Nord frost
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
      background = "#2e3440";
      foreground = "#d8dee9";
    };
    
    cursor = {
      text = "#2e3440";
      cursor = "#d8dee9";
    };
    
    normal = {
      black = "#3b4252";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#81a1c1";
      magenta = "#b48ead";
      cyan = "#88c0d0";
      white = "#e5e9f0";
    };
    
    bright = {
      black = "#4c566a";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#81a1c1";
      magenta = "#b48ead";
      cyan = "#8fbcbb";
      white = "#eceff4";
    };
  };
}
