{ ... }:

{
  # Ensure terminfo is available for terminal apps
  environment.extraOutputsToInstall = [ "terminfo" ];
}

