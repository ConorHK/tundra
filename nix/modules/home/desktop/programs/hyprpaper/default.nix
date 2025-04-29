{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.hyprpaper;
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
        preload = mkDefault [
          "./wallpapers/hashwall.png"
        ];
        wallpaper = mkDefault [
          ",tile:./wallpapers/hashwall.png"
        ];
      };
    };
  };
}
