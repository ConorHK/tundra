{
  inputs,
  flake,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    flake.nixosModules.roles
  ];

  styles.stylix.enableNixOs = false;
  system.boot.enable = false;

  services = {
    fail_2_ban.enable = true;
    sshserver.enable = true;
    uptimekuma = {
      enable = true;
      host = "100.96.40.127";
    };
  };

  users.users."driver".hashedPasswordFile = null;
  user = {
    name = "driver";
    extraOptions = {
      description = "admin";
      uid = 1000;
    };
  };

  networking.hostName = "vps";
  system.stateVersion = "25.05";
}
