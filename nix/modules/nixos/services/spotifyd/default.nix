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
  # if you want remote auth you need to run spotifyd auth on hosts
  # and make sure it can write to the cache dir
  # TODO: persist auth cache
  options.services.spotifydaemon = with types; {
    enable = lib.mkOption {
      description = "enable spotifyd";
      default = false;
      type = types.bool;
    };
    headless = lib.mkOption {
      description = "use on headless host";
      default = true;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    # force use of fallback resolvers
    networking.extraHosts = ''
      0.0.0.0 apresolve.spotify.com
    '';

    systemd.services.spotifyd = {
      environment = {
        PULSE_SERVER = "unix:///run/pulse/native";
      };
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "spotifyd";
      };
    };

    users.users.spotifyd = {
      isSystemUser = true;
      extraGroups = [ "pipewire" ];
      group = "spotifyd";
    };
    users.groups.spotifyd = { };

    networking.firewall.allowedTCPPorts = [
      57621
      59382
    ];

    networking.firewall.allowedUDPPorts = [ 5353 ];
    services.spotifyd = {
      enable = true;
      settings = {
        global = {
          device_name = config.networking.hostName;
          device_type = "speaker";
          bitrate = 320;
          initial_volume = 70;
          zeroconf_port = 59382;
          use_mpris = !cfg.headless;
          backend = "pulseaudio";
        };
      };
    };
  };
}
