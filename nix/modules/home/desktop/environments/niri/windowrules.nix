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
  config = mkIf cfg.enable {
    programs.niri.settings.window-rules = [
      {
        clip-to-geometry = true;
        draw-border-with-background = false;
      }

      {
        matches = [
          { is-floating = true; }
        ];
        shadow.enable = true;
      }

      {
        matches = [
          { app-id = "firefox"; }
          { app-id = "alacritty"; }
          { app-id = "steam"; }
        ];
        open-maximized = true;
      }

      {
        matches = [
          {
            app-id = "firefox";
            title = "Picture-in-Picture";
          }
        ];
        open-floating = true;
        default-floating-position = {
          x = 32;
          y = 32;
          relative-to = "bottom-right";
        };
        default-column-width = {
          fixed = 480;
        };
        default-window-height = {
          fixed = 270;
        };
      }

      {
        matches = [ { title = "Discord Popout"; } ];
        open-floating = true;
        default-floating-position = {
          x = 32;
          y = 32;
          relative-to = "bottom-right";
        };
      }

      {
        matches = [ { app-id = "pavucontrol"; } ];
        open-floating = true;
      }

      {
        matches = [ { app-id = "dialog"; } ];
        open-floating = true;
      }

      {
        matches = [ { app-id = "popup"; } ];
        open-floating = true;
      }

      {
        matches = [ { app-id = "nm-connection-editor"; } ];
        open-floating = true;
      }

      {
        matches = [ { app-id = "blueman-manager"; } ];
        open-floating = true;
      }
    ];
  };
}
