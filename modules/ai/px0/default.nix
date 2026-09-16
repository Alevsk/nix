{
  pkgs,
  lib,
  ...
}: {
  # Ensure ~/.local/bin is in PATH for the installed binary
  home.sessionPath = ["$HOME/.local/bin"];

  # Auto-install px0 from GitHub releases (not available in nixpkgs or brew)
  home.activation.installPx0 = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${lib.makeBinPath (with pkgs; [curl gnugrep gnused coreutils])}:$PATH"
    $DRY_RUN_CMD ${./setup/install-px0.sh}
  '';
}
