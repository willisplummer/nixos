{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  hl = config.homelab;
in
{
  homelab = {
    enable = true;
    baseDomain = "westernbeefs.com";
    timeZone = "America/New_York";
    cloudflare.dnsCredentialsFile = "/home/wmp224/cloudflare";
    services = {
      enable = true;
      homepage.enable = true;
      jellyfin.enable = true;
      keycloak = {
        enable = true;
        dbPasswordFile = "/home/wmp224/keycloak-db-password";
        cloudflared = {
          tunnelId = "2695fac5-0241-46ba-ad5a-30d7f9271f6c";
          credentialsFile = "/home/wmp224/.cloudflared/2695fac5-0241-46ba-ad5a-30d7f9271f6c.json";
        };
      };
    };
  };
}
