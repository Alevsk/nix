{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    go_1_25
  ];

  # Ensure GOPATH/bin is in PATH
  home.sessionPath = ["$HOME/go/bin"];

  # Auto-install Go tools not available in nixpkgs
  home.activation.installGoTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs.go_1_25}/bin:$PATH"
    export GOPATH="$HOME/go"
    export GOBIN="$HOME/go/bin"
    $DRY_RUN_CMD ${./setup/install-go-tools.sh}
  '';
}
