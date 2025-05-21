{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.heroic;
in
{
  options.desktop.programs.heroic = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "install heroic launcher";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      heroic
    ];
  };
}
