{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.display.greetd;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.display.greetd = {
    enable = mkEnableOption "greetd";
    command = mkOption {
      type = types.str;
      description = "Command to run after unlocking";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd \"${cfg.command}\"";
	  command = "${pkgs.hyprland}/bin/Hyprland";
          user = "wmp224";
        };
	default_session = initial_session;
      };
    };
  };
}
