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
  imports = [
    ./keybinds.nix
    ./monitors.nix
  ];
  options.desktop.environment.hyprland = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable hyprland desktop environment";
    };
    standalone = mkOption {
      default = false;
      type = bool;
      description = "use hyprland in homemanager standalone mode";
    };
    execOnceExtras = mkOption {
      default = [ ];
      type = listOf str;
      description = "programs to execute at startup";
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
      hyprpaper.enable = true;
      rofi.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = mkIf (!cfg.standalone) null;
      portalPackage = mkIf (!cfg.standalone) null;
      systemd = {
        variables = mkIf (!cfg.standalone) [ "--all" ];
        enable = true;
        enableXdgAutostart = true;
      };
      xwayland.enable = true;
      settings = {
        input.kb_layout = mkDefault "us";
        animation = "windows, 1, 3, default, slide";
        general = {
          gaps_in = 10;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = mkForce "0xFFAF875F";
        };
        misc =
          let
            FULLSCREEN_ONLY = 2;
          in
          {
            vrr = FULLSCREEN_ONLY;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            force_default_wallpaper = 0;
          };
        exec-once = [
          "hyprctl dispatch workspace 1"
        ] ++ cfg.execOnceExtras;
      };
    };
  };
}
