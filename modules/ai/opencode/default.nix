{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".config/opencode/opencode.json" = {
    source = ./opencode.json;
  };
}
