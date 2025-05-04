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
    battery.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable battery module";
    };
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      style = ''
        *{
          all: unset;
        }
      '';
      settings = [
        {
          name = "sidebar";
          layer = "top";
          position = "left";
          spacing = 5;
          modules-left = [ "clock" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [
            "wireplumber"
            "network"
          ] ++ (optionals cfg.battery.enable [ "battery" ]);
          "hyprland/workspaces" = {
            disable-scroll = true;
            on-click = "activate";
            format = "{icon}";
            format-icons = {
              active = "o";
              default = "•";
            };
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
            sort-by-number = true;
          };
          clock = {
            format = "{:%H\n%M\n--\n%d\n%m}";
          };
          network = {
            interval = 1;
            format = "";
            format-ethernet = "e:con";
            format-wifi = "w:con";
            format-disconnected = "n:dis";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname}";
            tooltip-format-disconnected = "disconnected";
          };
          wireplumber = {
            format = "v:{volume}%";
            max-volume = 100;
            scroll-step = 5;
          };
          battery = {
            states = {
              good = 70;
              warning = 30;
              critical = 15;
            };
            format = "b:{capacity}%";
            format-charging = "c:{capacity}%";
          };

        }
      ];
    };
  };
}
