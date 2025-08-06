{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.hardware.audio;
in
{
  options.hardware.audio = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hardware audio support";
    };
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      systemWide = true;
      socketActivation = true;
    };

    environment.systemPackages = with pkgs; [
      alsa-utils
      pulsemixer
      pavucontrol
    ];
  };
}
