{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
  fixMonitorPositions = pkgs.writeShellScriptBin "fix-monitor-positions" ''
    #!/usr/bin/env bash

    hyprctl keyword monitor "DP-1,2560x1440,0x0,1";
    hyprctl keyword monitor "DP-2,2560x1440,2560x0,1"
  '';
in
{
  config = mkIf cfg.enable {
    desktop.programs.waybar.outputs = "DP-1";
    home.packages = [
      fixMonitorPositions
    ];
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, g, exec, toggle_game_mode"
      ];
    };
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "1,monitor:DP-1"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:DP-1"
        "5,monitor:DP-1"
        "6,monitor:DP-1"
        "7,monitor:DP-1"
        "8,monitor:DP-1"
        "9,monitor:DP-2"
        "10,monitor:DP-2"
      ];
    };
    desktop.environment.hyprland.monitors = [
      {
        name = "DP-1";
        resolution = "2560x1440@144.00Hz";
        scale = "1";
        position = "0x0";
      }
      {
        name = "DP-2";
        resolution = "2560x1440@59.95Hz";
        scale = "1";
        position = "2560x0";
      }
    ];

  };
}
