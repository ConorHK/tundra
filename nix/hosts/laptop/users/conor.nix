{ flake, lib, ... }:
with lib.hm.gvariant;
{
  imports = [
    flake.homeModules.roles
  ];

  config = {
    roles.home = {
      development.enable = true;
      desktop.enable = true;
    };

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

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        sources = [
          (mkTuple [
            "xkb"
            "ie"
          ])
          (mkTuple [
            "xkb"
            "us"
          ])
        ];
      };
    };
  };

}
