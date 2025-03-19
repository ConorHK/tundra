{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.security.hardening;
in
{
  imports = [
    "${inputs.nix-mineral}/nix-mineral.nix"
  ];
  options.security.hardening = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable nix mineral hardening";
    };
  };

  config = mkIf cfg.enable {
    nm-overrides = {
      desktop.allow-multilib.enable = true;
      desktop.allow-unprivileged-userns.enable = true;
      desktop.home-exec.enable = true;
      usbguard-gnome-integr.ation.enable = true;
      desktop.yama-relaxed.enable = true;
      security.disable-intelme-kmodules.enable = true;
    };
  };
}
