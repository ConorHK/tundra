{
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    ../../modules/nixos/common-role.nix
  ];

  styles.stylix.enableNixOs = false;
  system.boot.enable = true;

  users.users."driver".hashedPasswordFile = null;
  user = {
    name = "driver";
    extraOptions = {
      description = "admin";
      uid = 1000;
    };
  };

  networking.hostName = "satelite";
  system.stateVersion = "25.05";
}
