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
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
    ];
  };
}
