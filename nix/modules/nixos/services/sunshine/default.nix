{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.sunshine-server;
in
{
  options.services.sunshine-server = with types; {
    enable = lib.mkOption {
      description = "enable sunshin";
      default = false;
      type = bool;
    };
  };
  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
