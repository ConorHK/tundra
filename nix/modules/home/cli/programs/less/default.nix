{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.less;
  shellCfg = config.cli.shells;
in
{
  options.cli.programs.less = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable pager";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      less = {
        enable = true;
      };
      zsh.sessionVariables = mkIf shellCfg.zsh.enable {
        LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      };
      fish.interactiveShellInit = mkIf shellCfg.fish.enable ''
        set -x LESSHISTFILE $XDG_CACHE_HOME/less/history
      '';
    };
  };
}
