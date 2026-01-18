{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nodejs_22
    yarn
    pnpm
    bun
    typescript
    prettier
    eslint_d
    playwright-test
  ];

  home.sessionVariables = {
    # Set npm global directory to avoid permission issues
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Add npm and bun global bin to PATH
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.bun/bin"
  ];

  # Auto-install tools not available in nixpkgs (browsers, global npm packages)
  home.activation.installNodePackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${lib.makeBinPath (with pkgs; [nodejs_22 bun playwright-test gawk gnugrep])}:$PATH"
    export NIX_STATE_HOME="${config.xdg.stateHome}"
    $DRY_RUN_CMD ${./setup/install-playwright.sh}
    $DRY_RUN_CMD ${./setup/install-ccusage.sh}
  '';
}
