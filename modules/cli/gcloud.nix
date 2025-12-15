{
  config,
  lib,
  pkgs,
  ...
}: let
  # Google Cloud SDK with required components
  # Using nixpkgs instead of Homebrew for proper macOS compatibility
  gcloudSdk = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];
in {
  # Install Google Cloud SDK via Nix (properly patched, no readlink errors)
  home.packages = [
    gcloudSdk
  ];

  # Environment variables for gcloud/kubectl integration
  home.sessionVariables = {
    # Use gcloud auth plugin for GKE authentication
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  # Zsh completions for gcloud
  programs.zsh.initExtra = ''
    # Google Cloud SDK completions
    if command -v gcloud &>/dev/null; then
      source "$(dirname $(dirname $(which gcloud)))/google-cloud-sdk/completion.zsh.inc" 2>/dev/null || true
    fi
  '';
}
