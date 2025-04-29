{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.sshserver;
in
{
  options.services.sshserver = with types; {
    enable = lib.mkOption {
      description = "enable sshd";
      default = false;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;

      };
    };
  };
}
