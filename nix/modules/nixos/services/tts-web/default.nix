{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tts-web;

  tts-web-script = pkgs.writeScriptBin "tts-web" ./tts-web.py;
in
{
  options.services.tts-web = {
    enable = mkEnableOption "TTS web service";

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "Port to run the TTS web service on";
    };

    user = mkOption {
      type = types.str;
      default = "tts-web";
      description = "User to run the service as";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "audio";
      extraGroups = [
        "audio"
        "pipewire"
      ];
    };

    systemd.services.tts-web = {
      description = "TTS Web Service";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "sound.target"
      ];

      serviceConfig = {
        ExecStart = "${tts-web-script}/bin/tts-web";
        User = cfg.user;
        Group = "audio";
        Restart = "always";
        RestartSec = 5;
      };

      environment = {
        PYTHONPATH = "${pkgs.python3.withPackages (ps: with ps; [ flask ])}/${pkgs.python3.sitePackages}";
      };
    };

    environment.systemPackages = with pkgs; [
      espeak-ng
      alsa-utils
      (python3.withPackages (ps: with ps; [ flask ]))
    ];
  };
}
