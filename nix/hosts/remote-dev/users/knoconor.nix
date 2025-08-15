{ config, inputs, ... }:
{
  imports = [
    ./secrets.nix

    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    ../../../modules/home/work-role.nix
    inputs.stylix.homeModules.stylix
    inputs.agenix.homeManagerModules.default
  ];

  config = {
    home.username = "knoconor";
    home.homeDirectory = "/home/knoconor";
    roles.home = {
      development.enable = true;
      work.enable = true;
    };

    programs.fish.shellAliases = {
      ns = "home-manager switch --flake .#knoconor@remote-dev";
    };

    home.sessionVariables.HOSTROLE = "dev";
    system.xdg.enable = true;

    programs.zsh = {
      enable = true;
      initExtra = ''
        if [ -z "$NO_INTERACTIVE" ] && [[ $- == *i* ]]; then
          exec fish
        fi
      '';
    };

    system.agenix.enable = true;

    cli = {
      multiplexers.zellij.enableAutoStart = true;
      shells = {
        fish.enable = true;
      };
    };
  };
}
