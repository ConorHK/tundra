# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  inputs,
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

    ../../modules/nixos/common-role.nix
    ../../modules/nixos/desktop-role.nix
    ../../modules/nixos/gaming-role.nix
    ../../modules/nixos/user.nix
  ];

  roles.nixos = {
    desktop = {
      enable = true;
      windowManager = "hyprland";
    };
    gaming.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
    };
    logitechMouse.enable = true;
  };

  desktop.programs.qemu.enable = true;

  system.boot = {
    secureBoot = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  sops.secrets."passwords/${config.networking.hostName}/${config.user.name}" = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };
  sops.secrets."homeassistant/dim_lights" = {
    sopsFile = ../secrets.yaml;
    owner = "${config.user.name}";
    mode = "0400";
  };
  sops.secrets."homeassistant/raise_lights" = {
    sopsFile = ../secrets.yaml;
    owner = "${config.user.name}";
    mode = "0400";
  };

  user = {
    name = "conor";
    extraOptions = {
      description = "admin";
      uid = 1000;
      shell = pkgs.fish;
    };
  };

  services.sunshine-server.enable = true;
  networking.hostName = "desktop";

  boot = {
    kernelParams = [
      # hibernate settings
      "resume_offset=533760"
      "acpi_osi=\"!Windows 2015\"" # see https://bbs.archlinux.org/viewtopic.php?pid=2227023
    ];
    resumeDevice = "/dev/disk/by-label/nixos";

    supportedFilesystems = mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
  };

  environment.systemPackages =
    with pkgs;
    let
      enableGameMode = pkgs.writeShellScriptBin "enable_game_mode" ''
        #!/usr/bin/env bash

        niri msg output DP-2 off
        URL=$(cat ${config.sops.secrets."homeassistant/dim_lights".path})
        curl -X POST $URL
      '';
      disableGameMode = pkgs.writeShellScriptBin "disable_game_mode" ''
        #!/usr/bin/env bash

        niri msg output DP-2 on
        URL=$(cat ${config.sops.secrets."homeassistant/raise_lights".path})
        curl -X POST $URL
      '';
      toggleGameMode = pkgs.writeShellScriptBin "toggle_game_mode" ''
        #!/usr/bin/env bash

        SENTINEL="/tmp/game_mode_enabled"

        if [ ! -f "$SENTINEL" ]; then
            enable_game_mode
            touch "$SENTINEL"
            notify-send "Game Mode" "Game mode enabled"
        else
            disable_game_mode
            rm $SENTINEL
            notify-send "Game Mode" "Game mode disabled"
        fi
      '';
    in
    [
      qmk-udev-rules
      enableGameMode
      disableGameMode
      toggleGameMode
    ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
    dumpcap.enable = true;
  };

  users.groups.wireshark.members = [ "conor" ];

  system.nixbuild.enable = true;
  chaotic.nyx.cache.enable = true;

  system.stateVersion = "25.05";
}
