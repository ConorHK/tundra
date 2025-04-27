{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
let
  cfg = config.roles.nixos.desktop;
in
with lib;
{
  imports = [
    flake.nixosModules.desktop
    flake.nixosModules.hardware
    flake.nixosModules.security
  ];
  options.roles.nixos.desktop = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable desktop role";
    };
  };
  config = mkIf cfg.enable {
    desktop.environment.gnome.enable = true;
    hardware.audio.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    security.yubikey.enable = true;
  };
}
