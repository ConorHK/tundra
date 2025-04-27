{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.hyprlock;
in
{
  options.desktop.programs.hyprlock =  {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprlock";
    };
  };
  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
  };
}
