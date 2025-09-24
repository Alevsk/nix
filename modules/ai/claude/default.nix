{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".claude/CLAUDE.md" = {
    source = ./CLAUDE.md;
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

    # Merge the configurations using jq
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq --argjson mcpConfig "$MCP_SERVERS" \
      '. * $mcpConfig' "$CLAUDE_CONFIG" > "$CLAUDE_CONFIG.tmp" && \
      mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"

    echo "Updated Claude MCP configuration"
  '';
}
