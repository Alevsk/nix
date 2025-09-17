{ ... }:

{
  # Aggregated system modules import to keep host config minimal.
  # Policy: modules are plain config by default; add options only when clearly useful.

  imports = [
    ./core.nix
    ./defaults.nix
    ./packages.nix
    ./fonts.nix
    ./applications.nix
    ./homebrew.nix
    ./proxychains.nix
  ];
}

