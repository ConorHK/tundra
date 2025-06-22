{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.niri;
  set-volume = config.lib.niri.actions.spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@";
  playerctl = config.lib.niri.actions.spawn "${pkgs.playerctl}/bin/playerctl";
in
{
  config = mkIf cfg.enable {
    programs.niri.settings.binds = with config.lib.niri.actions; {
      "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

      "XF86AudioPlay".action = playerctl "play-pause";
      "XF86AudioStop".action = playerctl "pause";
      "XF86AudioPrev".action = playerctl "previous";
      "XF86AudioNext".action = playerctl "next";

      "XF86AudioRaiseVolume".action = set-volume "5%+";
      "XF86AudioLowerVolume".action = set-volume "5%-";
      "Mod+Space".action = spawn "rofi" "-show" "drun" "-mode" "drun";
      "Mod+Return".action = spawn "alacritty";
      "Mod+X".action = spawn "wlogout";
      "Mod+Q".action = close-window;
      "Mod+F".action = expand-column-to-available-width;
      "Mod+Shift+F".action = maximize-column;

      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+K".action = focus-window-or-workspace-up;
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Down".action = focus-window-or-workspace-down;
      "Mod+Up".action = focus-window-or-workspace-up;
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+J".action = move-column-to-workspace-down;
      "Mod+Shift+K".action = move-column-to-workspace-up;
      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+Down".action = move-column-to-workspace-down;
      "Mod+Shift+Up".action = move-column-to-workspace-up;
      "Mod+Ctrl+Up".action = toggle-overview;

      "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;
      "Mod+C".action = center-visible-columns;
      "Mod+Tab".action = switch-focus-between-floating-and-tiling;

      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+Ctrl+R".action = reset-window-height;

      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";

      "Mod+S".action = toggle-window-floating;

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-workspace-down;
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-workspace-up;
      };
      "Mod+WheelScrollRight" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "Mod+WheelScrollLeft" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };

      "Print".action = screenshot;
    };
  };
}
