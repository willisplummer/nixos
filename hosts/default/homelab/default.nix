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
    baseDomain = "nixos.local";
    timeZone = "America/New_York";
    services = {
      enable = true;
      homepage.enable = true;
      jellyfin.enable = true;
    };
  };
}
