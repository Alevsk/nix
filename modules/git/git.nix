{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Lenin Alevski";
    userEmail = "alevsk.8772@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
