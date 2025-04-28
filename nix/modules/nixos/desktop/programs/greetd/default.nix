{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.greetd;
in
{
  options.desktop.programs.greetd = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable login greeter";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "Hyprland &> /dev/null"; # TODO: generalize
          user = config.user.name;
        };
        initial_session = default_session;
      };
    };
  };
}
