{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.spotifydaemon;
in
{
  options.services.spotifydaemon = with types; {
    enable = lib.mkOption {
      description = "enable spotifyd";
      default = false;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.spotifyd = {
      enable = true;
      settings = {
        global = {
          device_name = config.networking.hostName;
          device_type = "speaker";
          bitrate = 320;
          initial_volume = 70;
          zeroconf_port = 1025;
        };
      };
    };
  };
}
