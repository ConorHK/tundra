{
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
    ./cli
    ./system
    ./styles
  ];

  options.roles.home.common = {
    enable = mkOption {
      default = true;
      type = with types; bool;
      description = "enable common role";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ home-manager ];
      sessionVariables = {
        BROWSER = mkDefault "echo";
        LS_COLORS = mkForce "";
      };
      stateVersion = "25.05";
    };

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
    };

    cli = {
      shells.zsh.enable = mkDefault true;
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
