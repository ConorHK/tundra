{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.hypridle;
in
{
  options.desktop.programs.hypridle = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hypridle";
    };
  };
  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "pidof hyprlock || hyprlock ";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session ";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
