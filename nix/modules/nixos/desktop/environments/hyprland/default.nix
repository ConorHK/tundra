{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
in
{
  options.desktop.environment.hyprland = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprland desktop environment";
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = false;
    };
    desktop.programs = {
      greetd.enable = true;
      xdgportal.enable = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
