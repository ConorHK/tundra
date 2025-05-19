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
    inputs.stylix.homeModules.stylix
  ];

  config = {

    roles.home.development.enable = true;

    cli.programs.git = {
      defaultBranch = "mainline";
      email = "knoconor@amazon.com";
    };
    cli.multiplexers.zellij.enable = mkForce false;
    cli.programs.ssh.enable = mkForce false;
    system.xdg.enableUserDirectories = false;
  };
}
