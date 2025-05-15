{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.fail_2_ban;
in
{
  options.services.fail_2_ban = with types; {
    enable = lib.mkOption {
      description = "enable fail2ban";
      default = false;
      type = types.bool;
    };
  };
  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        multipliers = "1 2 4 8 16 32 64";
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };
  };
}
