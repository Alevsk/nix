{ lib, pkgs, config, ... }:

{
  # Create macOS application aliases for Nix and Home Manager apps
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2

      # Clean up old Nix aliases in /Applications
      find /Applications -name "Nix-*" -type f -delete 2>/dev/null || true
      rm -rf /Applications/Nix\ Apps

      # Find system applications from environment.systemPackages
      if [ -d "${env}/Applications" ]; then
        find "${env}/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
          app_name=$(basename "$app_path")
          src=$(readlink "$app_path")
          echo "creating alias for system app: $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
        done
      fi

      # Find Home Manager applications by looking for home-manager-applications in nix store
      for hm_apps_dir in $(find /nix/store -name "*home-manager-applications*" -type d 2>/dev/null | head -1); do
        if [ -d "$hm_apps_dir/Applications" ]; then
          find "$hm_apps_dir/Applications" -maxdepth 1 -name "*.app" -type l | while read -r app_path; do
            app_name=$(basename "$app_path")
            src=$(readlink "$app_path")
            echo "creating alias for home app: $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name" || echo "Failed to create alias for $app_name" >&2
          done
          break
        fi
      done
    '';
}

