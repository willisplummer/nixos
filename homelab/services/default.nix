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
    security.acme = {
      acceptTerms = true;
      defaults.email = "willisplummer@gmail.com";
      certs."nixos.local" = {
        listenHTTP = "0.0.0.0:80"; # Provide a dummy HTTP listener for ACME
        # Other necessary ACME options if applicable, but keep them minimal since ACME won't be actively used for this domain
      };

    };
    services.caddy = {
      enable = true;
      globalConfig = ''
        auto_https off
      '';
      ca = null;
      virtualHosts = {
        "http://${config.homelab.baseDomain}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
        "http://*.${config.homelab.baseDomain}" = {
          extraConfig = ''
            redir https://{host}{uri}
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
