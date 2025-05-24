{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.eza;
  shellCfg = config.cli.shells;
  aliases = {
    l = "eza -la";
    ls = "eza";
  };
in
{
  options.cli.programs.eza = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable 'ls' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      eza.enable = true;
      zsh.shellAliases = mkIf shellCfg.zsh.enable aliases;
      fish.shellAliases = mkIf shellCfg.fish.enable aliases;
    };
  };
}
