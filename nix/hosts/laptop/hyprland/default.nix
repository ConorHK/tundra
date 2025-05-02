{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
    ];

    wayland.windowManager.hyprland.settings = {
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl next"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_invert = false;
        workspace_swipe_cancel_ratio = 0.4;
      };
    };
  };
}
