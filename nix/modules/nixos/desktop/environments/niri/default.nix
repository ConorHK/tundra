{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.niri;
in
{
  options.desktop.environment.niri = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable niri desktop environment";
    };
  };
  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://niri.cachix.org" ];
      trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
    desktop.programs = {
      greetd = {
        enable = true;
        session = "${pkgs.niri}/bin/niri-session";
      };
      xdgportal.enable = true;
    };
    services.seatd.enable = true;
  };
}
