{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.uptimekuma;
in
{
  options.services.uptimekuma = with types; {
    enable = lib.mkOption {
      description = "enable uptimekuma";
      default = false;
      type = types.bool;
    };
    host = lib.mkOption {
      description = "hostname";
      default = "127.0.0.1";
      type = types.str;
    };
    port = lib.mkOption {
      description = "port";
      default = 3001;
      type = types.int;
    };
  };
  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        HOST = cfg.host;
        PORT = toString cfg.port;
      };
    };
  };
}
