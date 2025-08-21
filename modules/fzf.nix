_: {
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border"
      ];
      fileWidgetOptions = [
        "--preview 'head {}'"
      ];
      historyWidgetOptions = [
        "--sort"
      ];
    };
  };
}
