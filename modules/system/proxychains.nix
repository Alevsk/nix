{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.proxychains;
in {
  options.programs.proxychains = {
    enable = lib.mkEnableOption "proxychains system configuration";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.proxychains-ng;
      description = "Package to install for proxychains";
    };

    etcPath = lib.mkOption {
      type = lib.types.str;
      default = "proxychains.conf";
      description = "Relative path under /etc for proxychains configuration file";
    };

    config = lib.mkOption {
      type = lib.types.lines;
      # Matches the existing inline configuration from darwin-configuration.nix
      default = ''
        dynamic_chain
        proxy_dns
        tcp_read_time_out 15000
        tcp_connect_time_out 8000
        [ProxyList]
        socks5 127.0.0.1 1080
      '';
      description = "Contents of proxychains.conf";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    environment.etc."${cfg.etcPath}".text = cfg.config;
  };
}
