{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      ("--color=" + (
        "fg:#${config.lib.stylix.colors.base05},bg:#${config.lib.stylix.colors.base00}," +
        "hl:#${config.lib.stylix.colors.base0D}," +
        "fg+:#${config.lib.stylix.colors.base06},bg+:#${config.lib.stylix.colors.base01}," +
        "hl+:#${config.lib.stylix.colors.base0E}," +
        "border:#${config.lib.stylix.colors.base03},header:#${config.lib.stylix.colors.base0E}," +
        "gutter:#${config.lib.stylix.colors.base00},prompt:#${config.lib.stylix.colors.base0D}," +
        "pointer:#${config.lib.stylix.colors.base08},marker:#${config.lib.stylix.colors.base0B}," +
        "spinner:#${config.lib.stylix.colors.base0C},info:#${config.lib.stylix.colors.base0A}"
      ))
    ];
  };
}

