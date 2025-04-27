{
  inputs,
  flake,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.roles.home.common;
in
with lib;
{
  imports = [
    flake.homeModules.cli
    flake.homeModules.system
    inputs.nix-index-database.hmModules.nix-index
    flake.homeModules.styles
  ];

  options.roles.home.common = {
    enable = mkOption {
      default = true;
      type = with types; bool;
      description = "enable common role";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ home-manager ];
    nix = {
      settings = {
        auto-optimise-store = mkDefault true;
        experimental-features = [
          "nix-command"
            "flakes"
        ];
        use-xdg-base-directories = mkDefault true;
        warn-dirty = mkDefault false;
        trusted-users = [ config.home.username ];
      };

      package = mkForce pkgs.nixVersions.stable;
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    };

    cli = {
      shells.zsh.enable = true;
      programs = {
        bat.enable = true;
        btop.enable = true;
        comma.enable = true;
        duf.enable = true;
        dust.enable = true;
        eza.enable = true;
        fzf.enable = true;
        less.enable = true;
        nh.enable = true;
        ssh.enable = mkDefault true;
        zoxide.enable = true;
      };
    };

    system.xdg.enable = mkDefault true;
    styles.stylix.enableHome = mkDefault true;
  };
}
