{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".codex/AGENTS.md" = {
    source = ./AGENTS.md;
  };

  home.activation.updateCodexMcpConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Starting Codex MCP configuration update..."
    CODEX_CONFIG="$HOME/.codex/config.toml"
    MCP_SERVERS_FILE="${./mcp-servers.toml}"

    # Create .codex directory if it doesn't exist
    mkdir -p "$HOME/.codex"

    # Create config.toml if it doesn't exist
    if [ ! -f "$CODEX_CONFIG" ]; then
      echo "Creating new config.toml..."
      echo '[mcp_servers]' > "$CODEX_CONFIG"
    fi

    # Create temporary file with environment variable substitution
    TEMP_MCP=$(mktemp)

    # Replace all $VARIABLE patterns with values from .env if it exists
    if [ -f "$HOME/nix/.env" ]; then
      echo "Loading environment variables from .env..."
      cp "$MCP_SERVERS_FILE" "$TEMP_MCP"

      # Read each line from .env and perform substitution
      while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        # Replace $KEY with actual value in the TOML file
        sed -i.bak "s/\\\$$key/$value/g" "$TEMP_MCP"
      done < "$HOME/nix/.env"
      # Remove backup files
      rm -f "$TEMP_MCP.bak"
    else
      echo ".env file not found at $HOME/nix/.env - using defaults"
      cp "$MCP_SERVERS_FILE" "$TEMP_MCP"
    fi

    # Merge MCP servers configuration
    if [ -f "$TEMP_MCP" ]; then
      echo "Merging MCP servers configuration..."

      TEMP_OUTPUT=$(mktemp)
      TEMP_JSON=$(mktemp)

      # Convert TOML to JSON, merge, then convert back to TOML
      /run/current-system/sw/bin/tomlq -s '
        .[0] as $base |
        .[1] as $extra |
        $base |
        .mcp_servers = (($base.mcp_servers // {}) + ($extra.mcp_servers // {}))
      ' "$CODEX_CONFIG" "$TEMP_MCP" > "$TEMP_JSON"

      # Convert JSON to TOML format preserving all sections
      cat "$TEMP_JSON" | ${pkgs.jq}/bin/jq -r '
        # Output top-level keys (model, model_reasoning_effort, etc.)
        (to_entries[] |
          select(.key != "projects" and .key != "mcp_servers") |
          "\(.key) = \(.value | @json)"
        ),

        # Output projects section if it exists
        (if .projects then
          "",
          "[projects]"
        else empty end),
        (.projects // {} | to_entries[] |
          "",
          "[projects.\"\(.key)\"]",
          (.value | to_entries[] | "\(.key) = \(.value | @json)")
        ),

        # Output mcp_servers section
        (if .mcp_servers then
          "",
          "[mcp_servers]"
        else empty end),
        (.mcp_servers // {} | to_entries[] |
          "",
          "[mcp_servers.\(.key)]",
          (.value | to_entries[] | "\(.key) = \(.value | @json)")
        )
      ' > "$TEMP_OUTPUT"

      # Only replace if output is valid and not empty
      if [ -s "$TEMP_OUTPUT" ]; then
        cat "$TEMP_OUTPUT" > "$CODEX_CONFIG"
        echo "✓ Successfully merged MCP servers configuration"
      else
        echo "✗ Error: Failed to merge configuration, keeping original"
      fi

      rm -f "$TEMP_OUTPUT" "$TEMP_JSON" "$TEMP_MCP"
    else
      echo "Warning: MCP servers file not found"
    fi
  '';
}
