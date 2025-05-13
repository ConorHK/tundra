{ flake, ... }:
{
  imports = [
    flake.homeModules.roles
    ./hyprland
  ];

  config = {

    roles.home = {
      development.enable = true;
      desktop = {
        enable = true;
        windowManager = "hyprland";
      };
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

    cli.programs.qmk.enable = true;

    styles.stylix.enableHome = true;
  };

}
