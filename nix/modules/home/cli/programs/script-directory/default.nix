{
  inputs,
  config,
  lib,
  pkgs,
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
        fpath+="${inputs.script-directory.packages.${pkgs.system}.sd}/share/zsh/site-functions"
      '';
    };

    programs.fish = {
      interactiveShellInit = ''
        source ${inputs.script-directory.packages.${pkgs.system}.sd}/share/fish/vendor_completions.d/sd.fish
      '';
    };

    home = {
      sessionVariables.SD_ROOT = "$HOME/scripts";
      sessionPath = [
        "${config.home.homeDirectory}/scripts/.scripts"
      ];
      packages = [ inputs.script-directory.packages.${pkgs.system}.sd ];
    };
  };
}
