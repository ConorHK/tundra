
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
  options.desktop.environment.hyprland = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable hyprland desktop environment";
    };
  };
  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    desktop.programs = {
      hypridle.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;
    };
    programs = {
      kitty.enable = true;  # TODO: possibly remove
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
      xwayland.enable = true;
      settings = {
        input.kb_layout = mkDefault "us";
        decoration.rounding = 5;
        misc = let FULLSCREEN_ONLY = 2;
          in {
            vrr = FULLSCREEN_ONLY;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            force_default_wallpaper = 0;
          };
      };

    };
  };
}
