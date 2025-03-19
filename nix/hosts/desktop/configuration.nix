# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
    ./hardware-configuration.nix

    ./disks.nix
    inputs.disko.nixosModules.disko

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    flake.nixosModules.common-role
    flake.nixosModules.desktop-role
    flake.nixosModules.gaming-role
  ];

  hardware = {
    bluetooth = {
      enable = true;
    };
    logitechMouse.enable = true;
  };

  system.impermanence.enable = false;
  system.boot = {
    plymouth = true;
    secureBoot = true;
  };

  sops.secrets."passwords/${config.networking.hostName}/${config.user.name}" = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  user = {
    name = "conor";
    extraOptions = {
      description = "admin";
      uid = 1000;
    };
  };

  networking.hostName = "desktop";

  boot = {
    kernelParams = [
      # hibernate settings
      "resume_offset=533760"
      "acpi_osi=\"!Windows 2015\"" # see https://bbs.archlinux.org/viewtopic.php?pid=2227023
    ];
    resumeDevice = "/dev/disk/by-label/nixos";

    supportedFilesystems = mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  system.stateVersion = "25.05";
}
