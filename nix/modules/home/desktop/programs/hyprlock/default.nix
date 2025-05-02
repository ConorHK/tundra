{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.hyprlock;
in
{
  options.desktop.programs.hyprlock = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprlock";
    };
  };
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
    disable_loading_bar = true;
    hide_cursor = true;
    no_fade_in = false;
  };

  background = mkForce [
    {
      path = "screenshot";
      blur_passes = 3;
      blur_size = 8;
    }
  ];
      };
    };
  };
}
