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
  };
  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
    };
  };
}
