{
  config,
  inputs,
  flake,
  lib,
  ...
}:
let
  cfg = config.roles.nixos.common;
in
with lib;
{
  imports = [
    flake.nixosModules.hardware
    flake.nixosModules.security
    flake.nixosModules.services
    flake.nixosModules.styles
    flake.nixosModules.system
    flake.nixosModules.user
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
    environment.defaultPackages = mkForce [ ];
    home-manager = {
      extraSpecialArgs.inputs = inputs;
      useGlobalPkgs = true;
      useUserPackages = true;
    };
    nixpkgs.config.allowUnfree = true;

    security = {
      sudo = {
        wheelNeedsPassword = false;
        execWheelOnly = true;
      };
      sops.enable = true;
    };

    system = {
      nix.enable = true;
      boot.enable = true;
      locale.enable = true;
      tailscale.enable = true;
    };

    hardware.networking.enable = true;
    styles.stylix.enableNixOs = mkDefault true;
  };
}
