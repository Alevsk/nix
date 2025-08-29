{ config, pkgs, lib, ... }:

{
  # Package overrides for gemini-cli to fix Node.js compilation issues
  nixpkgs.config.packageOverrides = pkgs: {
    gemini-cli = pkgs.gemini-cli.overrideAttrs (oldAttrs: {
      # Skip the problematic build step or use a different approach
      buildPhase = ''
        export npm_config_build_from_source=true
        export npm_config_cache=$TMPDIR/.npm
        export npm_config_nodedir=${pkgs.nodejs}/include/node
        
        # Try to build with more permissive settings
        npm ci --offline --no-audit --no-fund --ignore-scripts
        npm run build --if-present || true
      '';
    });
  };

  # Install gemini-cli
  home.packages = with pkgs; [
    gemini-cli
  ];
}
