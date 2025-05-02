{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.hyprpaper;
  hashwall = ./wallpapers/hashwall.png;
in
{
  options.desktop.programs.hyprpaper = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprpaper";
    };
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = mkDefault [ hashwall ];
        wallpaper = mkDefault [ hashwall ];
      };
    };
  };
}
