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

  services = {
    sshd.enable = true;
  };

  users.users."driver".hashedPasswordFile = null;
  users.users."driver".initialPassword = "pass";
  user = {
    name = "driver";
    extraOptions = {
      description = "admin";
      uid = 1000;
    };
  };

  networking.hostName = "homebox";
  system.stateVersion = "25.05";
}
