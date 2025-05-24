{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.duf;
  shellCfg = config.cli.shells;
  aliases = {
    df = "duf";
  };
in
{
  options.cli.programs.duf = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable 'df' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duf ];
    programs = {
      zsh.shellAliases = mkIf shellCfg.zsh.enable aliases;
      fish.shellAliases = mkIf shellCfg.fish.enable aliases;
    };
  };
}
