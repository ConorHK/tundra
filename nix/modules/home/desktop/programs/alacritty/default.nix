{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.programs.alacritty;
in
with lib;
{
  options.desktop.programs.alacritty = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable alacritty terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 5;
              y = 5;
            };
            decorations_theme_variant = "Dark";
          };
          cursor = {
            style = "block";
            unfocused_hollow = true;
          };
        };
      };
    };
  };
}
