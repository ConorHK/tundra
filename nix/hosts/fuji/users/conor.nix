{ flake, ... }:
{
  imports = [
    flake.homeModules.roles
  ];

  config = {
    home = {
      sessionVariables = {
        BROWSER = "echo";
      };
      stateVersion = "25.05";
    };
  };
}
