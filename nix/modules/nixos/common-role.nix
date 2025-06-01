{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.roles.nixos.common;
in
with lib;
{
  imports = [
    ./hardware
    ./security
    ./services
    ./styles
    ./system
    ./user.nix
    inputs.nur.modules.nixos.default
    inputs.home-manager.nixosModules.default
  ];

  options.roles.nixos.common = {
    enable = mkOption {
      default = true;
      type = with types; bool;
      description = "enable common role";
    };
  };

  config = mkIf cfg.enable {
    environment.defaultPackages = mkForce [ pkgs.vim ];

    security = {
      sudo = {
        wheelNeedsPassword = false;
        execWheelOnly = true;
      };
      sops.enable = true;
    };

    system = {
      nix.enable = true;
      boot.enable = mkDefault true;
      locale.enable = true;
      tailscale.enable = true;
    };

    hardware.networking.enable = true;
    styles.stylix.enableNixOs = mkDefault true;
  };
}
