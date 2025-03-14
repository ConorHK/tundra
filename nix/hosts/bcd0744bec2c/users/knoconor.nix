{
  flake,
  lib,
  inputs,
  ...
}:
with lib;
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
    inputs.stylix.homeManagerModules.stylix
  ];

  config = {
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
