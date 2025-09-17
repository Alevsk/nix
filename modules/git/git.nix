{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Lenin Alevski";
    userEmail = "alevsk.8772@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNo+JZ6HwtwIkjEcFsdvuumgoKSMIYri54g5AwGT4/j";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = true;
      core.editor = "nvim";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };
}
