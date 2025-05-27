{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.fzf;
  shellCfg = config.cli.shells;
in
{
  options.cli.programs.fzf = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable fuzzy Finder";
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = mkIf shellCfg.zsh.enable true;
      enableFishIntegration = mkIf shellCfg.fish.enable true;
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
