{
  config,
  inputs,
  flake,
  lib,
  ...
}:
let
  cfg = config.roles.home.desktop;
in
with lib;
{
  imports = [
    flake.homeModules.desktop
    inputs.nur.modules.homeManager.default
  ];
  options.roles.home.desktop = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable desktop role";
    };
  };
  config = mkIf cfg.enable {
    desktop = {
      environment.gnome.enable = true;
      programs = {
        alacritty.enable = true;
        firefox.enable = true;
        spotify.enable = true;
      };
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      LIBSEAT_BACKEND = "logind";
    };

    xdg = {
      mimeApps = {
        enable = true;
        associations.added = {
          "video/mp4" = [ "org.gnome.Totem.desktop" ];
          "video/quicktime" = [ "org.gnome.Totem.desktop" ];
          "video/webm" = [ "org.gnome.Totem.desktop" ];
          "video/x-matroska" = [ "org.gnome.Totem.desktop" ];
          "image/gif" = [ "org.gnome.Loupe.desktop" ];
          "image/png" = [ "org.gnome.Loupe.desktop" ];
          "image/jpg" = [ "org.gnome.Loupe.desktop" ];
          "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        };
        defaultApplications = {
          "application/x-extension-htm" = "firefox";
          "application/x-extension-html" = "firefox";
          "application/x-extension-shtml" = "firefox";
          "application/x-extension-xht" = "firefox";
          "application/x-extension-xhtml" = "firefox";
          "application/xhtml+xml" = "firefox";
          "text/html" = "firefox";
          "x-scheme-handler/about" = "firefox";
          "x-scheme-handler/chrome" = [ "chromium-browser.desktop" ];
          "x-scheme-handler/ftp" = "firefox";
          "x-scheme-handler/http" = "firefox";
          "x-scheme-handler/https" = "firefox";
          "x-scheme-handler/unknown" = "firefox";

          "audio/*" = [ "mpv.desktop" ];
          "video/*" = [ "org.gnome.Totem.desktop" ];
          "video/mp4" = [ "org.gnome.Totem.desktop" ];
          "video/x-matroska" = [ "org.gnome.Totem.desktop" ];
          "image/*" = [ "org.gnome.loupe.desktop" ];
          "image/png" = [ "org.gnome.loupe.desktop" ];
          "image/jpg" = [ "org.gnome.loupe.desktop" ];
          "application/json" = [ "gnome-text-editor.desktop" ];
          "application/pdf" = "firefox";
          "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
          "x-scheme-handler/discord" = [ "discord.desktop" ];
          "x-scheme-handler/spotify" = [ "spotify.desktop" ];
          "application/toml" = "org.gnome.TextEditor.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
        };
      };
    };
  };
}
