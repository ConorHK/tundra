{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.niri;
in
{
  config = mkIf cfg.enable {
    desktop.programs.waybar.outputs = "DP-1";
    programs.niri.settings.binds = with config.lib.niri.actions; {
      "Mod+Shift+G".action = spawn "toggle_game_mode";
      "MouseForward".action = spawn "toggle_game_mode";
    };
    desktop.environment.niri.monitors = [
      {
        name = "DP-1";
        resolution = "2560x1440@144.00Hz";
        scale = "1";
        position = "0,0";
      }
      {
        name = "DP-2";
        resolution = "2560x1440@59.95Hz";
        scale = "1";
        position = "2560,0";
      }
    ];
  };
}
