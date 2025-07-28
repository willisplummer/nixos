{
  config,
  pkgs,
  lib,
  ...
}:
let
  service = "jellyfin";
  cfg = config.homelab.services.${service};
  homelab = config.homelab;
in
{
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${service}";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "The Free Software Media System";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };
  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = with pkgs; [
      (final: prev: {
        jellyfin-web = prev.jellyfin-web.overrideAttrs (
          finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          }
        );
      })
    ];
    services.${service} = {
      enable = true;
      user = homelab.user;
      group = homelab.group;
      openFirewall = true;
      dataDir = cfg.configDir;
    };
    services.caddy.virtualHosts."${config.homelab.baseDomain}".extraConfig = ''
      # Optional: Redirect /jellyfin to /jellyfin/ to ensure proper path handling
      redir /jellyfin /jellyfin/

      # Reverse proxy requests for /jellyfin/ and its subpaths
      reverse_proxy /jellyfin/* localhost:8096 {
          # Optional: Set appropriate headers for reverse proxying
          header_up Host {http.request.host}
          header_up X-Real-IP {remote_ip}
          header_up X-Forwarded-For {remote_ip}
          header_up X-Forwarded-Proto {http.request.scheme}
      }
    '';
  };
}
