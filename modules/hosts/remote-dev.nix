{ inputs, ... }:
{
  flake = {
    meta.users.remote-dev = {
      name = "Conor Knowles";
      username = "knoconor";
      email = "knoconor@amazon.com";
    };

    modules.homeManager.remote-dev = {
      imports = with inputs.self.modules.homeManager; [
        common
        development
        agenix
      ];

      programs.git = {
        userName = "Conor Knowles";
        userEmail = "knoconor@amazon.com";
        extraConfig.init.defaultBranch = "mainline";
      };

      home.username = "knoconor";
      home.homeDirectory = "/home/knoconor";

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
    };
  };
}
