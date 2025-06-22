{ inputs, ... }:
{
  imports = [
    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    inputs.stylix.homeModules.stylix
  ];

  config = {
    roles.home.development.enable = true;
    cli.shells.zsh.enable = false;
    cli.shells.fish.enable = true;
    programs.fish.shellAliases = {
      ns = "nh home switch .";
    };
    cli.programs.ssh = {
      extraHosts.fuji = {
        hostname = "fuji";
        user = "conor";
        port = 22;
        forwardAgent = true;
      };
      extraHosts.dns = {
        hostname = "dns";
        user = "conor";
        port = 22;
        forwardAgent = true;
      };
    };
  };
}
