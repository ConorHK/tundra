{ flake, lib, ... }:
with lib.hm.gvariant;
{
  imports = [
    flake.homeModules.roles
  ];

  config = {
    roles.home = {
      development.enable = true;
      desktop = {
        enable = true;
        windowManager = "hyprland";
      };
    };
    wayland.windowManager.hyprland.settings.input.kb_layout = "gb";
    desktop.environment.hyprland.monitors = [ 
      {
      name = "eDP-1";
      resolution = "1920x1080@60";
      scale = "1";
      position = "0x0";
      }
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
