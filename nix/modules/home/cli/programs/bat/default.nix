{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.bat;
  batWithGlow = pkgs.writeShellScriptBin "bat-with-glow" ''
    if [[ $1 == *.md ]]; then
      PAGER='bat' ${pkgs.glow}/bin/glow -p "$1"
    else
      ${pkgs.bat}/bin/bat --style='plain,rule,header' --paging=never "$1"
    fi
  '';
in
{
  options.cli.programs.bat = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable better text file viewer";
    };
    useGlow = mkOption {
      default = true;
      type = with types; bool;
      description = "use glow for better markdown preview";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        config = {
          pager = "less -FR";
        };
      };
    };
    home = {
      shellAliases = {
        bat =
          if cfg.useGlow then
            "${batWithGlow}/bin/bat-with-glow"
          else
            "bat --style='plain,rule,header' --paging=never";
        cat = "bat";
      };
    };
  };
}
