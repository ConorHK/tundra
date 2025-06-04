{ inputs, ... }:
{
  imports = [
    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    ../../../modules/home/work-role.nix
    inputs.stylix.homeModules.stylix
  ];

  home.username = "knoconor";
  home.homeDirectory = "/home/knoconor";
  roles.home = {
    development.enable = true;
    work.enable = true;
  };

  cli.shells.zsh.enable = false;
  cli.shells.fish.enable = true;
  programs.fish.shellAliases = {
    ns = "home-manager switch --flake .#knoconor@remote-dev";
  };

  home.sessionVariables.HOSTROLE = "dev";
  system.xdg.enable = true;

  cli.multiplexers.zellij.enableAutoStart = true;

  # cli.shells.zsh = {
  #   configExtras = {
  #     pre-q = {
  #       content = ". \"$HOME/.local/share/amazon-q/shell/zprofile.pre.zsh\"";
  #       priority = 500;
  #     };
  #     post-q = {
  #       content = ". \"$HOME/.local/share/amazon-q/shell/zprofile.post.zsh\"";
  #       priority = 1500;
  #     };
  #   };
  # };
}
