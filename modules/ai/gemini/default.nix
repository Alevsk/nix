{ config, lib, pkgs, ... }:

{
  home.file.".gemini/GEMINI.md" = {
    source = ./GEMINI.md;
  };
}
