{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
let
  cfg = config.roles.nixos.desktop;
in
with lib;
{
  imports = [
    flake.nixosModules.desktop
    flake.nixosModules.hardware
    flake.nixosModules.security
  ];
  options.roles.nixos.desktop = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable desktop role";
    };
    windowManager = mkOption {
      default = "gnome";
      type = str;
      description = "window manager to use";
    };
  };
  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://nixpkgs-wayland.cachix.org" ];
      trusted-public-keys = [
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };
    desktop = {
      environment.gnome.enable = cfg.windowManager == "gnome";
      environment.hyprland.enable = cfg.windowManager == "hyprland";
    };

    hardware.audio.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    security.yubikey.enable = false;  # TODO: need to rethink
  };
}
