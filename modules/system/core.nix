{ ... }:

{
  # Core system settings consolidated for simplicity.
  # - nix: enable flakes & nix-command
  # - nixpkgs: allowUnfree
  # - programs: base program toggles (zsh, gnupg)
  # - terminal: extra outputs (terminfo)

  # nix
  nix.settings.experimental-features = "nix-command flakes";

  # nixpkgs
  nixpkgs.config.allowUnfree = true;

  # programs
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on macOS
  };

  # terminal
  environment.extraOutputsToInstall = [ "terminfo" ];
}

