{
  config,
  lib,
  pkgs,
  ...
}: {
  # Merge OpenCode configuration into ~/.config/opencode/opencode.json with env substitution
  home.activation.setupOpencode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"

    # Create ~/.config/opencode/opencode.json if it doesn't exist
    if [ ! -f "$OPENCODE_CONFIG" ] || [ ! -s "$OPENCODE_CONFIG" ]; then
      mkdir -p "$(dirname "$OPENCODE_CONFIG")"
      echo '{}' > "$OPENCODE_CONFIG"
    fi

    # Read configuration from JSON file
    OPENCODE_CONTENT='${builtins.readFile ./opencode.json}'

    # Replace all $VARIABLE patterns with values from .env if it exists
    if [ -f "$HOME/nix/.env" ]; then
      echo "Loading environment variables from .env..."
      OPENCODE_SUBSTITUTED="$OPENCODE_CONTENT"

      # Read each line from .env and perform substitution
      while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        # Replace $KEY with actual value in the JSON
        OPENCODE_SUBSTITUTED=$(echo "$OPENCODE_SUBSTITUTED" | sed "s/\\\$$key/$value/g")
      done < "$HOME/nix/.env"
    else
      echo ".env file not found at $HOME/nix/.env - using defaults"
      OPENCODE_SUBSTITUTED="$OPENCODE_CONTENT"
    fi

    # Merge the configurations using jq
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson opencodeConfig "$OPENCODE_SUBSTITUTED" \
      '. * $opencodeConfig' "$OPENCODE_CONFIG" > "$OPENCODE_CONFIG.tmp" && \
      mv "$OPENCODE_CONFIG.tmp" "$OPENCODE_CONFIG"

    echo "Updated OpenCode configuration"
  '';
}
