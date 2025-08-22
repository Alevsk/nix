{ config, pkgs, lib, ... }:

let
  # Import all available themes
  themes = {
    default = import ./themes/default.nix;
    cyberpunk = import ./themes/cyberpunk.nix;
    ocean = import ./themes/ocean.nix;
    dracula = import ./themes/dracula.nix;
  };
  
  # Current selected theme (change this to switch themes)
  selectedTheme = "default";  # Options: "default", "cyberpunk", "ocean", "dracula"
  
  currentTheme = themes.${selectedTheme};
  
  # Generate p10k configuration from theme
  generateP10kConfig = theme: ''
    # Auto-generated p10k configuration for ${theme.name} theme
    # ${theme.description}
    
    # Left prompt elements
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(${lib.concatStringsSep " " theme.p10k.left_prompt_elements})
    
    # Right prompt elements  
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${lib.concatStringsSep " " theme.p10k.right_prompt_elements})
    
    # Segment separators
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='${theme.p10k.icons.left_segment_separator}'
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='${theme.p10k.icons.right_segment_separator}'
    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='${theme.p10k.icons.left_subsegment_separator}'
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='${theme.p10k.icons.right_subsegment_separator}'
    
    # Directory colors
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=${theme.p10k.colors.dir_foreground}
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=${theme.p10k.colors.dir_background}
    
    # VCS colors
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=${theme.p10k.colors.vcs_clean_foreground}
    ${lib.optionalString (theme.p10k.colors ? vcs_clean_background) 
      "typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=${theme.p10k.colors.vcs_clean_background}"}
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=${theme.p10k.colors.vcs_dirty_foreground}
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=${theme.p10k.colors.vcs_dirty_foreground}
    ${lib.optionalString (theme.p10k.colors ? vcs_dirty_background) 
      "typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=${theme.p10k.colors.vcs_dirty_background}"}
    ${lib.optionalString (theme.p10k.colors ? vcs_dirty_background) 
      "typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=${theme.p10k.colors.vcs_dirty_background}"}
    
    # Time colors
    typeset -g POWERLEVEL9K_TIME_FOREGROUND=${theme.p10k.colors.time_foreground}
    
    # Additional colors based on theme
    ${lib.optionalString (theme.p10k.colors ? context_foreground) 
      "typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=${theme.p10k.colors.context_foreground}"}
    ${lib.optionalString (theme.p10k.colors ? context_background) 
      "typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=${theme.p10k.colors.context_background}"}
    ${lib.optionalString (theme.p10k.colors ? os_icon_foreground) 
      "typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=${theme.p10k.colors.os_icon_foreground}"}
    ${lib.optionalString (theme.p10k.colors ? os_icon_background) 
      "typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=${theme.p10k.colors.os_icon_background}"}
    ${lib.optionalString (theme.p10k.colors ? prompt_char_ok_foreground) 
      "typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=${theme.p10k.colors.prompt_char_ok_foreground}"}
    ${lib.optionalString (theme.p10k.colors ? prompt_char_error_foreground) 
      "typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=${theme.p10k.colors.prompt_char_error_foreground}"}
    
    # General settings
    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
  '';
  
in {
  # Export the current theme and utilities
  _module.args = {
    inherit currentTheme themes selectedTheme generateP10kConfig;
  };
  
  # Create theme files in home directory
  home.file.".p10k-themes" = {
    source = pkgs.writeTextDir "current-theme" ''
      Current theme: ${selectedTheme}
      Description: ${currentTheme.description}
      
      Available themes:
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: theme: "- ${name}: ${theme.description}") themes)}
    '';
    recursive = true;
  };
}
