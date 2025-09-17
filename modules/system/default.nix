{...}: {
  # Aggregated system modules import to keep host config minimal.
  # Policy: Modules are plain config by default; add options only when clearly useful.

  imports = [
    ./applications.nix
    ./core.nix
    ./defaults.nix
    ./fonts.nix
    ./homebrew.nix
    ./packages.nix
    ./proxychains.nix
  ];
}
