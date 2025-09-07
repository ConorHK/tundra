{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.rofi;
in
{
  options.desktop.programs.signal = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable signal";
    };
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.signal-desktop
    ];
  };
}
