{ pkgs, config, ... }:

{
  imports = [
    ./modules/system/proxychains.nix
    ./modules/system/homebrew.nix
    ./modules/system/packages.nix
    ./modules/system/fonts.nix
    ./modules/system/terminal.nix
    ./modules/system/applications.nix
    ./modules/system/dock.nix
    ./modules/system/ui.nix
    ./modules/system/programs.nix
  ];

  system.primaryUser = "alevsk";

  programs.proxychains.enable = true;

  # Allow unfree packages (e.g., 1Password)
  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
