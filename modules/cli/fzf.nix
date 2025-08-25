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
      "--height=60%"
      "--layout=reverse"
      "--border=rounded"
      "--margin=1,2"
      "--padding=1"
      "--preview-window=right:50%:wrap"
      "--bind=ctrl-u:preview-page-up,ctrl-d:preview-page-down"
      "--bind=ctrl-f:page-down,ctrl-b:page-up"
      "--prompt='❯ '"
      "--pointer='▶'"
      "--marker='✓'"
      "--header='Press CTRL-F/B for page navigation, CTRL-U/D for preview scroll'"
    ];
  };
}

