{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
   resize = pkgs.writeShellScriptBin "resize" ''
    #!/usr/bin/env bash

    # Initially inspired by https://github.com/exoess

    # Getting some information about the current window
    # windowinfo=$(hyprctl activewindow) removes the newlines and won't work with grep
    hyprctl activewindow > /tmp/windowinfo
    windowinfo=/tmp/windowinfo

    # Run slurp to get position and size
    if ! slurp=$(slurp); then
    		exit
    fi

    # Parse the output
    pos_x=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 1)
    pos_y=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 2)
    size_x=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 1)
    size_y=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 2)

    # Keep the aspect ratio intact for PiP
    if grep "title: Picture-in-Picture" $windowinfo; then
    		old_size=$(grep "size: " $windowinfo | cut -d " " -f 2)
    		old_size_x=$(echo $old_size | cut -d , -f 1)
    		old_size_y=$(echo $old_size | cut -d , -f 2)

    		size_x=$(((old_size_x * size_y + old_size_y / 2) / old_size_y))
    		echo $old_size_x $old_size_y $size_x $size_y
    fi

    # Resize and move the (now) floating window
    grep "fullscreen: 1" $windowinfo && hyprctl dispatch fullscreen
    grep "floating: 0" $windowinfo && hyprctl dispatch togglefloating
    hyprctl dispatch moveactive exact $pos_x $pos_y
    hyprctl dispatch resizeactive exact $size_x $size_y
  '';

in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slurp
    ];
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun -mode drun"
        "SUPER, Return, exec, alacritty"
        "SUPER, x, exec, wlogout"
        "SUPER_SHIFT, F, exec, firefox"
        "SUPER, R, exec, ${resize}/bin/resize"
        "SUPER, Q, killactive,"
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
        "SUPER, 0, workspace,10"
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
        "SUPER,u, togglespecialworkspace"
        "SUPERSHIFT,u, movetoworkspace,special"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

    };
  };
}
