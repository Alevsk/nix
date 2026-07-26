{...}: {
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
    zsh.enable = true; # default shell on macOS
  };

  # terminal
  environment.extraOutputsToInstall = ["terminfo"];

  # Disable the nix-darwin HTML manual build. nixpkgs-unstable removed the
  # `--toc-depth` flag from nixos-render-docs (use --sidebar-depth), but
  # nix-darwin master still passes it in doc/manual/default.nix, breaking
  # darwin-manual-html.drv. Re-enable once nix-darwin ships the fix.
  documentation.doc.enable = false;

  # The `darwin-uninstaller` tool evaluates its own default config
  # (pkgs/darwin-uninstaller/configuration.nix) which leaves docs enabled,
  # so it rebuilds the same broken darwin-manual-html.drv. Disable it until
  # nix-darwin fixes the manual. Re-enable together with the line above.
  system.tools.darwin-uninstaller.enable = false;
}
