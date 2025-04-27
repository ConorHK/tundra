{ flake, inputs, ... }:
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeManagerModules.stylix
  ];

  config = {
    roles.home.development.enable = true;
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
