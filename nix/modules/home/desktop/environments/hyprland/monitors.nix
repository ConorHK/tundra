{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.hyprland;
in
{
  options.desktop.environment.hyprland = with types; {
    monitors = mkOption {
      type = listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "monitor name/identifier";
            default = "";
          };
          resolution = mkOption {
            type = str;
            description = "monitor resolution";
            default = "preferred";
          };
          position = mkOption {
            type = str;
            description = "monitor position (e.g. '0,0')";
            default = "auto";
          };
          scale = mkOption {
            type = str;
            description = "monitor scaling factor";
            default = "auto";
          };
        };
      });
      default = [ ];
      description = "Hyprland monitor configurations";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = map (m: "${m.name},${m.resolution},${m.position},${m.scale}") cfg.monitors;
    };
  };
}
