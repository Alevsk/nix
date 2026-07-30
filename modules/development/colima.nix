{
  config,
  lib,
  pkgs,
  ...
}: {
  # Declarative Colima configuration.
  # Writes ~/.colima/default/colima.yaml.template; the activation below copies it
  # to colima.yaml when the template is newer. NOTE: `colima start` rewrites
  # colima.yaml itself, so the live config had drifted to memory:64 / disk:500
  # from a past manual `colima start --memory 64 …`. Bumping values here + a
  # rebuild re-asserts them; then run `colima stop && colima start` (no --memory
  # flag) so the VM boots from this file.
  #
  # SIZING (128 GB M4 Max): memory=32 leaves macOS ~96 GB. The desktop baseline is
  # ~50-70 GB (Chrome + Antigravity), so a 64 GiB VM oversubscribed RAM and drove
  # macOS into compressor/swap thrash (load avg 27, 56% sys). 32 GiB fits the
  # container stack ONLY IF the JVM services are bounded (trino -Xmx, neo4j
  # heap+pagecache, per-service mem_limit) — an unbounded neo4j/trino OOM-killed
  # the VM even at 64 GiB, so more RAM is not the fix. Don't exceed ~48 here.
  # See wiki/cloud-macbookpro/006-colima-memory-oversubscription.md.
  home.file.".colima/default/colima.yaml.template" = {
    text = ''
      cpu: 8
      disk: 500
      memory: 32
      arch: aarch64
      runtime: docker
      vmType: vz
      mountType: virtiofs
      autoActivate: true
      network:
        address: false
        dns: []
        dnsHosts: {}
        hostAddresses: false
      hostname: colima
      env: {}
    '';
  };

  # Initialize the actual config from template if it doesn't exist
  home.activation.colimaConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    COLIMA_DIR="$HOME/.colima/default"
    TEMPLATE="$COLIMA_DIR/colima.yaml.template"
    CONFIG="$COLIMA_DIR/colima.yaml"

    # Create directory if it doesn't exist
    mkdir -p "$COLIMA_DIR"

    # If config is a symlink, remove it (from previous Nix setup)
    if [ -L "$CONFIG" ]; then
      $DRY_RUN_CMD rm -f "$CONFIG"
    fi

    # Copy template to config if config doesn't exist or if template is newer
    if [ ! -f "$CONFIG" ] || [ "$TEMPLATE" -nt "$CONFIG" ]; then
      $DRY_RUN_CMD cp "$TEMPLATE" "$CONFIG"
      $DRY_RUN_CMD chmod 644 "$CONFIG"
      echo "Colima config initialized/updated from template"
    fi
  '';
}
