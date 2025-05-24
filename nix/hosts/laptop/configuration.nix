{
  inputs,
  flake,
  lib,
  pkgs,
  ...
}:

with lib;
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    flake.nixosModules.roles
  ];

  roles.nixos.desktop = {
    enable = true;
    windowManager = "hyprland";
  };

  hardware.bluetooth.enable = true;

  system = {
    locale.keyboard = "gb";
    boot.secureBoot = true;
    power.battery.enable = true;
    stateVersion = "25.05";
  };

  # sops.secrets."passwords/${config.networking.hostName}/${config.user.name}" = {
  #   sopsFile = ../secrets.yaml;
  #   neededForUsers = true;
  # };

  users.mutableUsers = true;
  user = {
    name = "conor";
    extraOptions = {
      description = "Conor";
      uid = 1000;
      hashedPasswordFile = null;
      shell = pkgs.fish;
    };
  };

  networking.hostName = "laptop";

  boot = {
    supportedFilesystems = mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
