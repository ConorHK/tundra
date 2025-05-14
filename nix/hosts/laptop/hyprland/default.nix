{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
  laptop_lid_switch = pkgs.writeShellScriptBin "laptop_lid_switch" ''
    #!/usr/bin/env bash

    if grep open /proc/acpi/button/lid/LID0/state; then
      hyprctl keyword monitor "eDP-1, 2256x1504@60, 0x0, 1"
    else
      if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
        hyprctl keyword monitor "eDP-1, disable"
      else
        systemctl suspend
      fi
    fi
  '';

in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
    ];

    desktop.programs.waybar.battery.enable = true;
    wayland.windowManager.hyprland.settings = {
      bindel = [
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl next"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindl = [
        ",switch:Lid Switch, exec, ${laptop_lid_switch}/bin/laptop_lid_switch"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_invert = false;
        workspace_swipe_cancel_ratio = 0.4;
      };
    };
  };
}
