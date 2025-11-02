{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNo+JZ6HwtwIkjEcFsdvuumgoKSMIYri54g5AwGT4/j";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Lenin Alevski";
        email = "alevsk.8772@gmail.com";
      };
      init.defaultBranch = "main";
      push.default = "simple";
      pull.rebase = true;
      core.editor = "nvim";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };
}
