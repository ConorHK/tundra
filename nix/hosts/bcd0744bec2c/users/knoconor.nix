{
  flake,
  lib,
  inputs,
  ...
}:
with lib;
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeManagerModules.stylix
  ];

  config = {

    roles.home.development.enable = true;

    cli.programs.git = {
      defaultBranch = "mainline";
      email = "knoconor@amazon.com";
    };
    cli.multiplexers.zellij.enable = mkForce false;
    home = {
      stateVersion = "25.05";
    };
    cli.programs.ssh.enable = mkForce false;
    # nix.settings.use-xdg-base-directories = false;
    system.xdg.enableUserDirectories = false;
  };
}
