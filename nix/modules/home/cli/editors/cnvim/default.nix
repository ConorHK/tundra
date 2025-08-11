{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.cli.editors.cnvim;
  aliases = {
    vim = "nvim";
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
    home.sessionVariables.EDITOR = "nvim";
    home.packages = [ inputs.cnvim.packages.${pkgs.system}.nightly ];

    home.shellAliases = aliases;
  };
}
