{
  config,
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
    categoryOverrides = mkOption {
      type = with types; nullOr (attrsOf bool);
      default = null;
      description = "optional set of categories to enable/disable in neovim configuration";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "cnvim";

    cnvim = {
      enable = true;
      packageDefinitions.replace = mkIf (cfg.categoryOverrides != null) {
        cnvim =
          _:
          {
            categories = cfg.categoryOverrides;
          };
      };
      packageNames = [ "cnvim" ];
    };

    programs = {
      zsh.shellAliases = mkIf shellCfg.zsh.enable aliases;
      fish.shellAliases = mkIf shellCfg.fish.enable aliases;
    };
  };
}
