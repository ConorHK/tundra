{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.system.boot;
in
with lib;
{
  imports = with inputs; [
    lanzaboote.nixosModules.lanzaboote
  ];

  options.system.boot = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable booting";
    };
    plymouth = mkOption {
      default = false;
      type = with types; bool;
      description = "enable plymouth boot splash";
    };
    secureBoot = mkOption {
      default = false;
      type = with types; bool;
      description = "enable secureboot";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        efibootmgr
        efitools
        efivar
        fwupd
      ]
      ++ lib.optionals cfg.secureBoot [ sbctl ];

    boot = {
      kernelParams = lib.optionals cfg.plymouth [
        "boot.shell_on_fail"
        "quiet"
        "splash"
        "loglevel=3"
        "udev.log_level=0"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      initrd.verbose = lib.mkIf cfg.plymouth false;
      consoleLogLevel = lib.mkIf cfg.plymouth 0;
      loader.timeout = lib.mkIf cfg.plymouth 0;
      initrd.systemd.enable = true;
      plymouth = {
        enable = cfg.plymouth;
        theme = "splash";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "splash" ];
          })
        ];
      };

      lanzaboote = mkIf cfg.secureBoot {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
        };

        systemd-boot = {
          enable = !cfg.secureBoot;
          configurationLimit = 20;
          editor = false;
        };
      };

    };
  };
}
