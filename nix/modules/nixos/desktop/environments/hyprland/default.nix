
{
  config,
  pkgs,
  lib,
  ... 
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
in
{
  options.desktop.environment.hyprland = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprland desktop environment";
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    environment.systemPackages = [
      pkgs.kitty  # TODO: remove possibly
    ];
  };
}
