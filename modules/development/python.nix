{
  pkgs,
  lib,
  ...
}: {
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.activation.installUvTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="/opt/homebrew/bin:$PATH"
    $DRY_RUN_CMD ${./setup/install-uv-tools.sh}
  '';
}
