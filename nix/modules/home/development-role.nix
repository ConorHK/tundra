{
  config,
  lib,
  ...
}:
let
  cfg = config.roles.home.development;
in
with lib;
{
  options.roles.home.development = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable development role";
    };
  };
  config = mkIf cfg.enable {
    cli = {
      editors.cnvim.enable = true;
      multiplexers.zellij.enable = true;

      programs = {
        atuin.enable = true;
        git.enable = true;
        gpg.enable = true;
        jq.enable = true;
        networking-tools.enable = true;
        nix-your-shell.enable = true;
        ripgrep.enable = true;
        script-directory.enable = true;
        wget.enable = true;
      };
    };
  };
}
