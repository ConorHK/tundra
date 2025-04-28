{
  config,
  flake,
  lib,
  ...
}:
let
  cfg = config.roles.home.desktop;
in
with lib;
{
  imports = [
    flake.homeModules.desktop
  ];
  options.roles.home.desktop = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable desktop role";
    };
    windowManager = mkOption {
      default = "gnome";
      type = str;
      description = "window manager to use";
    };

  };
  config = mkIf cfg.enable {
    desktop = {
      environment."${cfg.windowManager}".enable = true;
      programs = {
        alacritty.enable = true;
        firefox.enable = true;
        spotify.enable = true;
      };
    };

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      LIBSEAT_BACKEND = "logind";
    };
  };
}
