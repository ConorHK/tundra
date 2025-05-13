{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.qmk;
in
{
  options.cli.programs.qmk = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable qmk";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qmk
    ];
  };
}

