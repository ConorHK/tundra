
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
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, ${config.desktops.addons.rofi.package}/bin/rofi -show drun -mode drun"
        "SUPER, Return, exec, alacritty"
        "SUPER, x, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "SUPER_SHIFT, F, exec, firefox"
        "SUPER_SHIFT, Q, killactive,"
        "SUPER, F, Fullscreen,0"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER, Left, movefocus, l"
        "SUPER, Right, movefocus, r"
        "SUPER, Up, movefocus, u"
        "SUPER, Down, movefocus, d"
        "SUPER_SHIFT, h, swapwindow, l"
        "SUPER_SHIFT, l, swapwindow, r"
        "SUPER_SHIFT, k, swapwindow, u"
        "SUPER_SHIFT, j, swapwindow, d"
        "SUPER_SHIFT, Left, swapwindow, l"
        "SUPER_SHIFT, Right, swapwindow, r"
        "SUPER_SHIFT, Up, swapwindow, u"
        "SUPER_SHIFT, Down, swapwindow, d"
        "SUPER, S, togglefloating,"
        "SUPER, 1, workspace,01"
        "SUPER, 2, workspace,02"
        "SUPER, 3, workspace,03"
        "SUPER, 4, workspace,04"
        "SUPER, 5, workspace,05"
        "SUPER, 6, workspace,06"
        "SUPER, 7, workspace,07"
        "SUPER, 8, workspace,08"
        "SUPER, 9, workspace,09"
        "SUPER, 10, workspace,10"
        "SUPER_SHIFT, 1, movetoworkspacesilent,01"
        "SUPER_SHIFT, 2, movetoworkspacesilent,02"
        "SUPER_SHIFT, 3, movetoworkspacesilent,03"
        "SUPER_SHIFT, 4, movetoworkspacesilent,04"
        "SUPER_SHIFT, 5, movetoworkspacesilent,05"
        "SUPER_SHIFT, 6, movetoworkspacesilent,06"
        "SUPER_SHIFT, 7, movetoworkspacesilent,07"
        "SUPER_SHIFT, 8, movetoworkspacesilent,08"
        "SUPER_SHIFT, 9, movetoworkspacesilent,09"
        "SUPER_SHIFT, 0, movetoworkspacesilent,10"
      ];
      binde = [  # repeat
      ];
    };
  };
}
