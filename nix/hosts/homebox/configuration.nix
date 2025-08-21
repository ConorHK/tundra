{
  inputs,
  lib,
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

  # TODO: make UEFI and BIOS boot modules
  system.boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    devices = lib.mkForce ["/dev/sda"];
    efiSupport = false;
    useOSProber = false;
  };

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
