{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.xdgportal;
  isHyprlandEnabled = config.desktop.environment.hyprland.enable;
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
      config.common = {
        default = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" =
          if isHyprlandEnabled == "hyprland" then "hyprland" else "gnome";
        "org.freedesktop.impl.portal.Screenshot" =
          if isHyprlandEnabled == "hyprland" then "hyprland" else "gnome";
      };
      config.hyprland.default = ["gtk" "hyprland"];
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
      ]; # TODO: generalize
    };
  };
}
