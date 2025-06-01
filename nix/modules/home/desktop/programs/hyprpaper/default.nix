{
  self,
  config,
  lib,
  pkgs,
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
        preload = mkDefault [ "${self.packages.${pkgs.system}.wallpapers}/wallpapers/hashwall.png" ];
        wallpaper = mkDefault [
          ",tile:${self.packages.${pkgs.system}.wallpapers}/wallpapers/hashwall.png"
        ];
      };
    };
  };
}
