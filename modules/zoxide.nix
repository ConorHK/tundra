_: {
  flake.modules.homeManager.zoxide = {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
