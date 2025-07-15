{ ... }:
{
  imports = [
    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    ../../../modules/home/desktop-role.nix
    ../../../modules/home/gaming-role.nix
    ./hyprland
    ./niri
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

    cli.shells.zsh.enable = false;
    cli.shells.fish.enable = true;
    programs.fish.shellAliases = {
      nt = "nh os test .";
      ns = "nh os switch .";
      nb = "nh os boot .";
    };

    styles.stylix.enableHome = true;
  };

}
