_: {
  flake.modules.homeManager.eza = {
    programs.eza.enable = true;
    home.shellAliases = {
      l = "eza -la";
      ls = "eza";
    };
  };
}
