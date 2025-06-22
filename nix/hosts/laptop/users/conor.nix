{ pkgs, ... }:
{
  imports = [
    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    ../../../modules/home/desktop-role.nix
  ];

  config = {
    roles.home = {
      development.enable = true;
      desktop = {
        enable = true;
        windowManager = "niri";
      };
    };
    programs.niri.settings.input.keyboard.xkb.layout = "gb";
    desktop.environment.niri.monitors = [
      {
        name = "eDP-1";
        resolution = "1920x1080@60";
        scale = "1";
        position = "0,0";
      }
    ];
    home.packages = with pkgs; [
      brightnessctl
    ];

    cli.programs.ssh.extraHosts.server = {
      hostname = "server.goat-lionfish.ts.net";
      user = "mustang";
      port = 22;
    };
    cli.programs.git = {
      defaultBranch = "main";
      email = "dev@conorknowles.com";
    };
    cli.shells.zsh.enable = false;
    cli.shells.fish.enable = true;
    programs.fish.shellAliases = {
      nt = "nh os test .";
      ns = "nh os switch .";
      nb = "nh os boot .";
    };

    styles.stylix.enableHome = true;

    # dconf.settings = {
    #   "org/gnome/desktop/input-sources" = {
    #     sources = [
    #       (mkTuple [
    #         "xkb"
    #         "ie"
    #       ])
    #       (mkTuple [
    #         "xkb"
    #         "us"
    #       ])
    #     ];
    #   };
    # };
  };

}
