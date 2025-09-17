{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".codex/AGENTS.md" = {
    source = ./AGENTS.md;
  };
}
