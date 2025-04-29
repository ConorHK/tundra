{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.waybar;
in
{
  options.desktop.programs.waybar = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable waybar";
    };
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = [
        {
          layer = "top";
          position = "left";
        }
      ];
    };
  };
}
