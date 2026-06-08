{
  lib,
  pkgs,
  config,
  ...
}: {
  # Create macOS application aliases for Nix and Home Manager apps
  #
  # Rationale:
  # - Provide a single UX surface in /Applications so spotlight/launchpad find both
  #   system (nix-darwin) and user (Home Manager) apps without users navigating to
  #   ~/Applications/Home Manager Apps.
  # Implementation notes:
  # - Overrides upstream behavior with mkForce to ensure aliases are created during
  #   activation. Tradeoff: imperative-ish script, but practical for macOS.
  # - The Home Manager search iterates all matching outputs (no head -1) to avoid
  #   missing apps when multiple profiles/derivations exist.
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = ["/Applications"];
    };
  in
    lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2

      # Track processed app names to avoid duplicate aliasing across multiple HM outputs
      SEEN_DIR=$(/usr/bin/mktemp -d 2>/dev/null || mktemp -d)

      # Clean up old Nix aliases in /Applications (alias files, not real .app bundles)
      find /Applications -maxdepth 1 -name "*.app" -not -type d -delete 2>/dev/null || true
      find /Applications -name "Nix-*" -type f -delete 2>/dev/null || true
      rm -rf /Applications/Nix\ Apps

      # Find system applications from environment.systemPackages
      if [ -d "${env}/Applications" ]; then
        find "${env}/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
          app_name=$(basename "$app_path")
          if [ -e "$SEEN_DIR/$app_name" ]; then
            continue
          fi
          : > "$SEEN_DIR/$app_name"
          src=$(readlink "$app_path")
          echo "creating alias for system app: $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
        done
      fi

      # Find Home Manager applications from the current profile only
      HM_PROFILE="/Users/alevsk/.local/state/home-manager/gcroots/current-home"
      if [ -L "$HM_PROFILE" ]; then
        hm_gen=$(readlink "$HM_PROFILE")
        hm_path=$(readlink "$hm_gen/home-path" 2>/dev/null || true)
        if [ -d "$hm_path/Applications" ]; then
          find "$hm_path/Applications" -maxdepth 1 -name "*.app" -type l -print0 |
          while IFS= read -r -d $'\0' app_path; do
            app_name=$(basename "$app_path")
            if [ -e "$SEEN_DIR/$app_name" ]; then
              continue
            fi
            : > "$SEEN_DIR/$app_name"
            src=$(readlink "$app_path")
            echo "creating alias for home app: $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
          done
        fi
      fi

      # Cleanup seen directory
      rm -rf "$SEEN_DIR"
    '';
}
