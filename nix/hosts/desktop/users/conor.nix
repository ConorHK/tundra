{ flake, ... }:
{
  imports = [
    flake.homeModules.roles
  ];

  config = {

    roles.home = {
      development.enable = true;
      desktop.enable = true;
      gaming.enable = true;
    };

    cli.programs.ssh.extraHosts.server = {
      hostname = "goosebox.org";
      user = "mustang";
      port = 22;
    };
    cli.programs.git = {
      defaultBranch = "main";
      email = "dev@conorknowles.com";
    };
    styles.stylix.enableHome = false;
  };

}
