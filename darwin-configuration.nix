{ pkgs, config, ... }:

{
  imports = [
    ./modules/system/default.nix
  ];

  system.primaryUser = "alevsk";

  programs.proxychains.enable = true;

  # System-wide defaults and base programs are imported from modules/system/default.nix

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
