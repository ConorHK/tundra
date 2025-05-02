{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.greetd;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  options.desktop.programs.greetd = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable login greeter";
    };
    session = mkOption {
      default = "${pkgs.hyprland}/bin/Hyprland";
      type = with types; str;
      description = "session to use";
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.greeter.group = "greeter";
      groups.greeter = { };
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --remember --cmd ${cfg.session}";
          user = "greeter";
        };
        initial_session = {
          command = "${cfg.session}";
          user = config.user.name;
        };
      };
    };
  };
}
