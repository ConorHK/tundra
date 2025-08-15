{ inputs, ... }:
{
  flake = {
    meta.users.remote-dev = {
      name = "Conor Knowles";
      username = "knoconor";
      email = "knoconor@amazon.com";
    };

    modules.homeManager.remote-dev = {
      imports = [
        inputs.self.modules.homeManager.development
      ];

      programs.git = {
        userName = "Conor Knowles";
        userEmail = "knoconor@amazon.com";
        extraConfig.init.defaultBranch = "mainline";
      };

      home.username = "knoconor";
      home.homeDirectory = "/home/knoconor";
      roles.home = {
        development.enable = true;
        work.enable = true;
      };

      programs.fish.shellAliases = {
        ns = "home-manager switch --flake .#knoconor@remote-dev";
      };

      home.sessionVariables.HOSTROLE = "dev";
      system.xdg.enable = true;

      programs.zsh = {
        enable = true;
        initExtra = ''
          if [ -z "$NO_INTERACTIVE" ] && [[ $- == *i* ]]; then
            exec fish
              fi
        '';
      };

      system.agenix.enable = true;

      cli = {
        multiplexers.zellij.enableAutoStart = true;
        shells = {
          fish.enable = true;
        };
      };
    };
  };
}
