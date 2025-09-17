{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".claude/CLAUDE.md" = {
    source = ./CLAUDE.md;
  };
}
