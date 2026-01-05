{
  config,
  lib,
  pkgs,
  dockerRuntime,
  ...
}: let
  runtimeConfigs = {
    colima = {
      socketPath = "${config.home.homeDirectory}/.colima/default/docker.sock";
      contextName = "colima";
    };
    docker-desktop = {
      socketPath = "${config.home.homeDirectory}/.docker/run/docker.sock";
      contextName = "desktop-linux";
    };
  };

  selected = runtimeConfigs.${dockerRuntime};
in {
  # Set DOCKER_HOST declaratively
  home.sessionVariables = {
    # DOCKER_HOST = "unix://${selected.socketPath}";
    DOCKER_HOST = "";
  };

  # Set docker context on activation
  home.activation.dockerContextSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if command -v docker &> /dev/null; then
      if [ -S "${selected.socketPath}" ]; then
        $DRY_RUN_CMD docker context use "${selected.contextName}" 2>/dev/null || true
      else
        echo "Note: Docker socket not found at ${selected.socketPath}"
        echo "Start ${dockerRuntime} to enable Docker."
      fi
    fi
  '';
}
