{
  config,
  inputs,
  flake,
  lib,
  pkgs,
  ...
}:

with lib;
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./disks.nix
    inputs.disko.nixosModules.disko

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    flake.nixosModules.common-role
    flake.nixosModules.desktop-role
  ];

  common-role = {
    enable = true;
    styling = true;
  };

  hardware.bluetooth.enable = true;

  system = {
    locale.keyboard = "gb";
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
    };
  };

  networking.hostName = "laptop";

  boot = {
    supportedFilesystems = mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "25.05";
}
