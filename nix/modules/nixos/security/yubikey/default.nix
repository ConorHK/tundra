{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.security.yubikey;
in
{
  options.security.yubikey = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable yubikey";
    };
  };

  config = mkIf cfg.enable {
    security.pam.yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
      id = [ "24665489" ];
    };
    services.udev.packages = [ pkgs.yubikey-personalization ];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

    services.pcscd.enable = true;
  };
}
