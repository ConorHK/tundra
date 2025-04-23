{
  config,
  inputs,
  flake,
  lib,
  ...
}:
let
  cfg = config.common-role;
in
with lib;
{
  imports = [
    flake.nixosModules.hardware
    flake.nixosModules.security
    flake.nixosModules.styles
    flake.nixosModules.system
    flake.nixosModules.user
    inputs.nur.modules.nixos.default
    inputs.home-manager.nixosModules.default
  ];

  options.common-role = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable common role";
    };
    styling = mkOption {
      default = false;
      type = with types; bool;
      description = "enable nixos styling";
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
    styles.stylix.enableNixOs = optionals cfg.styling true;
  };
}
