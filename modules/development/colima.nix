{
  config,
  lib,
  pkgs,
  ...
}: {
  # Declarative Colima configuration
  # Creates a template at ~/.colima/custom/colima.yaml.template
  # and copies it to the actual config location if it doesn't exist
  home.file.".colima/custom/colima.yaml.template" = {
    text = ''
      cpu: 8
      disk: 100
      memory: 50
      arch: aarch64
      runtime: docker
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
    COLIMA_DIR="$HOME/.colima/custom"
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
