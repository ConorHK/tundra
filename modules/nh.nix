_: {
  flake.modules.homeManager.nh = {
    programs.nh.enable = true;
    home.sessionVariables.NH_NO_CHECKS = "true"; # required for determinate nix use
  };
}
