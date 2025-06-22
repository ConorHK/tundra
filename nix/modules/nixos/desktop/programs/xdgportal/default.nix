{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.xdgportal;
in
{
  options.desktop.programs.xdgportal = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable xdgportal support";
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      config.common.default = "*";
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
      ]; # TODO: generalize
    };
  };
}
