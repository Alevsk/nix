{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".claude/CLAUDE.md" = {
    source = ./CLAUDE.md;
  };

  # Copy agents folder to ~/.claude/agents
  home.file.".claude/agents" = {
    source = ./agents;
    recursive = true;
  };

  # Merge MCP servers into existing ~/.claude.json
  home.activation.setupClaudeMCP = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CLAUDE_CONFIG="$HOME/.claude.json"

    # Create ~/.claude.json if it doesn't exist
    if [ ! -f "$CLAUDE_CONFIG" ]; then
      echo '{}' > "$CLAUDE_CONFIG"
    fi

    # Read MCP servers configuration from JSON file
    MCP_SERVERS='${builtins.readFile ./mcp-servers.json}'

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

    # Merge the configurations using jq
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson mcpConfig "$MCP_SERVERS_SUBSTITUTED" \
      '. * $mcpConfig' "$CLAUDE_CONFIG" > "$CLAUDE_CONFIG.tmp" && \
      mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"

    echo "Updated Claude MCP configuration"
  '';
}
