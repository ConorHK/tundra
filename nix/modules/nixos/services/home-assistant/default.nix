{
  config,
  lib,
  ...
}:

let
  cfg = config.services.homeassistant;
  homeAssistantVersion = "stable";
  configPath = "/home/${config.user.name}/storage/homeassistant/";
  timezone = "Europe/Dublin";

  usbDevice = "/dev/ttyUSB0";
in
# TODO: initial load requires mkdir ~/storage/homeassistant and reboot
{
  options.services.homeassistant = with lib.types; {
    enable = lib.mkOption {
      description = "enable homeassistant";
      default = false;
      type = types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = lib.mkDefault "podman";

      containers.homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:${homeAssistantVersion}";
        autoStart = true;
        volumes = [
          "${configPath}:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment.TZ = timezone;
        extraOptions = [
          "--network=host"
          "--device=${usbDevice}:${usbDevice}"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
