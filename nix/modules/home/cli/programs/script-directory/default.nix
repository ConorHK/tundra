{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.script-directory;
in
{
  options.cli.programs.script-directory = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable script directory handler";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      initContent = ''
        fpath+="${inputs.script-directory}/share/zsh/site-functions"
      '';
    };

    home = {
      # sessionVariables.SD_ROOT = "$HOME/scripts";
      # sessionPath = [
      #   "${config.home.homeDirectory}/scripts/.scripts"
      # ];
      # packages = [ inputs.script-directory.packages.${pkgs.system}.sd ];
    };
  };
}
