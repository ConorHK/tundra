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
  config = mkIf cfg.enable {
    desktop.programs.waybar.outputs = "DP-1";
  };
}
