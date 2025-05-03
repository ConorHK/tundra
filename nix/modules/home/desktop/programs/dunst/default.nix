{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.dunst;
in
{
  options.desktop.programs.dunst = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable dunst notifcation daemon";
    };
  };
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = mkForce "Monospace";
          offset = "30x50";
        };
      };
    };
  };
}
