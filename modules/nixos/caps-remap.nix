{ lib, config, pkgs, ... }:
let
  cfg = config.caps-remap;
in
{
  options.caps-remap = {
    enable = lib.mkEnableOption "enable caps remap module";
  };

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {

            main = {
              capslock = "overload(control, esc)";
            };
          };
        };
      };
    };
  };
}
