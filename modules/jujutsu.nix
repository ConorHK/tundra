_: {
  flake.modules.homeManager.jujutsu =
    { config, ... }:
    {
      assertions = [
        {
          assertion = config.programs.git.userName != "";
          message = "jujutsu module requires programs.git.userName to be set";
        }
        {
          assertion = config.programs.git.userEmail != "";
          message = "jujutsu module requires programs.git.userEmail to be set";
        }
      ];
      programs.jujutsu = {
        enable = true;
        settings = {
          ui.default_command = "log";
          user = {
            email = config.programs.git.userEmail;
            name = config.programs.git.userName;
          };
        };
      };
    };
}
