{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.wlsunset;
in
{
  options.desktop.programs.wlsunset =  {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable wlsunset night light";
    };
  };
  config = mkIf cfg.enable {
    services.wlsunset = {
      enable = true;
      latitude = "53.33306";
      longitude = "-6.24889";
    };
  };
}
