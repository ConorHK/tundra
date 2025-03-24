{
  inputs,
  flake,
  lib,
  ...
}:
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
  styles.stylix.enableNixOs = true;
}
