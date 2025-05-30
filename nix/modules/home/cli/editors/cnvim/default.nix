{
  config,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.editors.cnvim;
  shellCfg = config.cli.shells;
  aliases = {
    vim = "cnvim";
  };
in
{
  options.cli.editors.cnvim = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable custom nvim package";
    };
  };

  config = mkIf cfg.enable {
    imports = [ inputs.cnvim.homeModule ];
    home.sessionVariables.EDITOR = "cnvim";

    cnvim = {
      enable = true;
      packageNames = [ "cnvim" ];
    };

    programs = {
      zsh.shellAliases = mkIf shellCfg.zsh.enable aliases;
      fish.shellAliases = mkIf shellCfg.fish.enable aliases;
    };
  };
}
