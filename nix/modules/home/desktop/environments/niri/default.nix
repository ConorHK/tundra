{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.niri;
in
{
  imports = [
    ./keybinds.nix
    ./monitors.nix
    ./windowrules.nix
    inputs.niri.homeModules.niri
  ];
  options.desktop.environment.niri = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable niri desktop environment";
    };
  };
  config = mkIf cfg.enable {
    nix.settings = {
      extra-trusted-substituters = [ "https://niri.cachix.org" ];
      extra-trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
    programs.niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        spawn-at-startup = [
          { command = [ "${lib.getExe pkgs.dunst}" ]; }
          { command = [ "${lib.getExe pkgs.hyprpaper}" ]; }
          { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
          { command = [ "${lib.getExe pkgs.wlsunset}" ]; }
        ];
        xwayland-satellite = {
          enable = true;
        };
        environment = {
          CLUTTER_BACKEND = "wayland";
          DISPLAY = ":0";
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          XDG_CURRENT_DESKTOP = "niri";
        };
        input = {
          keyboard.xkb.layout = mkDefault "us";
          touchpad = {
            click-method = "button-areas";
            dwt = true;
            dwtp = true;
            natural-scroll = false;
            scroll-method = "two-finger";
            tap = true;
            tap-button-map = "left-right-middle";
            middle-emulation = true;
            accel-profile = "adaptive";
          };
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = true;
          workspace-auto-back-and-forth = true;
        };
        screenshot-path = "~/media/pictures/screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png";
        gestures = {
          hot-corners.enable = true;
        };
        layout = {
          focus-ring.enable = false;
          border = {
            enable = true;
            width = 1;
          };
          shadow = {
            enable = true;
          };
          preset-column-widths = [
            { proportion = 0.25; }
            { proportion = 0.5; }
            { proportion = 0.75; }
            { proportion = 1.0; }
          ];
          default-column-width = {
            proportion = 0.5;
          };

          gaps = 6;
          struts = {
            left = 0;
            right = 0;
            top = 0;
            bottom = 0;
          };
        };

        overview = {
          backdrop-color = "transparent";
        };

        hotkey-overlay.skip-at-startup = true;
      };
    };
    desktop.programs = {
      dunst.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      rofi.enable = true;
      waybar.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;
    };

  };
}
