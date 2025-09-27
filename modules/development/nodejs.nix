{
  pkgs,
  lib,
  ...
}: {
  # Node.js packages installed via npm/npx (using homebrew node)
  # Install these packages globally after system rebuild:
  # npm install -g pnpm playwright

  home.sessionVariables = {
    # Set npm global directory to avoid permission issues
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Add npm global bin to PATH
  home.sessionPath = ["$HOME/.npm-global/bin"];

  # Auto-install npm packages on activation
  home.activation.installNodePackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${./setup/install-playwright.sh}
  '';
}
