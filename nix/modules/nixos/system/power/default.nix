{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.power;
in
{
  options.system.power = {
    battery.enable = mkOption {
      default = false;
      description = "enable better battery support";
      type = types.bool;
    };
  };

  config = mkIf cfg.battery.enable {
    powerManagement.powertop.enable = true; # enable powertop auto tuning on startup.

    services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles - thanks System76!!!
    services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
    services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
    services.tlp = {
      enable = true; # Enable TLP (better than gnomes internal power manager)
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
        WIFI_PWR_ON_AC = 0;
        WIFI_PWR_ON_BAT = 0;
      };
    };
  };
}
