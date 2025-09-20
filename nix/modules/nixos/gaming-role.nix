{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.roles.nixos.gaming;
in
with lib;
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  options.roles.nixos.gaming = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable gaming role";
    };
  };
  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    hardware = {
      uinput.enable = true;
      steam-hardware.enable = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          mesa
        ];
      };
    };

    services.ratbagd.enable = true;

    chaotic.mesa-git.enable = true;
    chaotic.mesa-git.fallbackSpecialisation = false;

    services.pipewire.lowLatency.enable = true;

    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };

          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 0;
            amd_performance_level = "high";
          };

          custom = {
            start = "${lib.getExe pkgs.libnotify} 'GameMode started'";
            end = "${lib.getExe pkgs.libnotify} 'GameMode ended'";
          };
        };

      };
      gamescope.enable = true;
      steam = {
        enable = true;
        platformOptimizations.enable = true;
        package = pkgs.steam.override {
          extraPkgs =
            p: with p; [
              mangohud
              gamemode
            ];
        };
        dedicatedServer.openFirewall = false;
        remotePlay.openFirewall = false;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      winetricks
      wineWowPackages.waylandFull
      adwsteamgtk
      heroic
    ];

    services.udev.packages = with pkgs; [
      game-devices-udev-rules
    ];
  };
}
