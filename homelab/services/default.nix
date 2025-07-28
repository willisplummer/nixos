{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.homelab.services = {
    enable = lib.mkEnableOption "Settings and services for the homelab";
  };

  config = lib.mkIf config.homelab.services.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      globalConfig = ''
        local_certs
      '';
      virtualHosts = {
        "${config.homelab.baseDomain}" = {
          extraConfig = ''
            tls internal
          '';
        };
      };
    };
  };

  imports = [
    ./homepage
    ./jellyfin
  ];
}
