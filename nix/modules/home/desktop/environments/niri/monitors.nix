{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.niri;
in
{
  options.desktop.environment.niri = with types; {
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
      description = "niri monitor configurations";
    };
  };

  config = mkIf cfg.enable {
    programs.niri.settings.outputs = builtins.listToAttrs (
      map (monitor: {
        inherit (monitor) name;
        value = {
          enable = true;
          mode = mkIf (monitor.resolution != "preferred") (
            let
              # Remove refresh rate suffix if present
              resolutionOnly = builtins.head (builtins.split "@" monitor.resolution);
              parts = builtins.split "x" resolutionOnly;
            in
            {
              width = lib.toInt (builtins.elemAt parts 0);
              height = lib.toInt (builtins.elemAt parts 2);
            }
          );
          position = mkIf (monitor.position != "auto") (
            let
              parts = builtins.split "," monitor.position;
            in
            {
              x = lib.toInt (builtins.elemAt parts 0);
              y = lib.toInt (builtins.elemAt parts 2);
            }
          );
          scale = mkIf (monitor.scale != "auto") (lib.toInt monitor.scale);
        };
      }) cfg.monitors
    );
  };
}
