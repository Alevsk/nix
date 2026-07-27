{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".gemini/GEMINI.md" = {
    source = ./GEMINI.md;
  };

  # Merge MCP servers into existing ~/.gemini/config/mcp_config.json, ~/.gemini/antigravity/mcp_config.json, and ~/.gemini/antigravity-ide/mcp_config.json
  home.activation.setupGeminiMCP = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Read MCP servers configuration from JSON file
    MCP_SERVERS='${builtins.readFile ./mcp_config.json}'

    # Replace all $VARIABLE patterns with values from .env if it exists
    if [ -f "$HOME/nix/.env" ]; then
      echo "Loading environment variables from .env..."
      # Create a temporary variable with substituted values
      MCP_SERVERS_SUBSTITUTED="$MCP_SERVERS"

      # Read each line from .env and perform substitution
      while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        # Replace $KEY with actual value in the JSON
        MCP_SERVERS_SUBSTITUTED=$(echo "$MCP_SERVERS_SUBSTITUTED" | sed "s/\\\$$key/$value/g")
      done < "$HOME/nix/.env"
    else
      echo ".env file not found at $HOME/nix/.env - using defaults"
      MCP_SERVERS_SUBSTITUTED="$MCP_SERVERS"
    fi

    # Config files list to update
    GEMINI_CONFIGS=(
      "$HOME/.gemini/config/mcp_config.json"
      "$HOME/.gemini/antigravity/mcp_config.json"
      "$HOME/.gemini/antigravity-ide/mcp_config.json"
    )

    for GEMINI_CONFIG in "''${GEMINI_CONFIGS[@]}"; do
      # Create parent directory if it doesn't exist
      mkdir -p "$(dirname "$GEMINI_CONFIG")"

      # Create JSON file if it doesn't exist
      if [ ! -f "$GEMINI_CONFIG" ] || [ ! -s "$GEMINI_CONFIG" ]; then
        echo '{"mcpServers":{}}' > "$GEMINI_CONFIG"
      fi

      # Merge the configurations using jq
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson mcpConfig "$MCP_SERVERS_SUBSTITUTED" \
        '. * $mcpConfig' "$GEMINI_CONFIG" > "$GEMINI_CONFIG.tmp" && \
        mv "$GEMINI_CONFIG.tmp" "$GEMINI_CONFIG"

      echo "Updated Gemini MCP configuration at $GEMINI_CONFIG"
    done
  '';
}
