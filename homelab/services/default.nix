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
    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = "willisplummer@gmail.com";
    #   certs = {
    #     "${config.homelab.baseDomain}" = {
    #       listenHTTP = "0.0.0.0:80";
    #     };
    #   }; # don't try to issue certs for .local
    # };

    services.caddy = {
      enable = true;
      globalConfig = ''
        local_certs
      '';
      virtualHosts = { };
      # acmeCA = null;
      # virtualHosts = {
      #   "${config.homelab.baseDomain}" = {
      #     extraConfig = ''
      #       tls internal
      #     '';
      #   };
      # };
    };
  };

  imports = [
    ./homepage
    ./jellyfin
  ];
}
