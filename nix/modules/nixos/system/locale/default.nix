{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.locale;
in
{
  options.system.locale = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable system locale configuration";
    };
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = lib.mkDefault "en_IE.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_IE.UTF-8";
        LC_IDENTIFICATION = "en_IE.UTF-8";
        LC_MEASUREMENT = "en_IE.UTF-8";
        LC_MONETARY = "en_IE.UTF-8";
        LC_NAME = "en_IE.UTF-8";
        LC_NUMERIC = "en_IE.UTF-8";
        LC_PAPER = "en_IE.UTF-8";
        LC_TELEPHONE = "en_IE.UTF-8";
        LC_TIME = "en_IE.UTF-8";
      };
    };
    time.timeZone = "Europe/Dublin";

    services.xserver = {
      xkb.layout = mkDefault "us";
    };
    console.keyMap = mkDefault "us";
  };
}
