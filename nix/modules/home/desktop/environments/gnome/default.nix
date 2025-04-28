{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.environment.gnome;
in
{
  options.desktop.environment.gnome = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable GNOME desktop environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.pop-shell
      pop-launcher
    ];

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };


    xdg = {
      mime.enable = true;
      systemDirs.data = [
        "${config.home.homeDirectory}/.nix-profile/share/applications"
        "${config.home.homeDirectory}/state/nix/profile/share/applications"
      ];
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
          "audio/*" = [ "mpv.desktop" ];
          "video/*" = [ "org.gnome.Totem.desktop" ];
          "video/mp4" = [ "org.gnome.Totem.desktop" ];
          "video/x-matroska" = [ "org.gnome.Totem.desktop" ];
          "image/*" = [ "org.gnome.loupe.desktop" ];
          "image/png" = [ "org.gnome.loupe.desktop" ];
          "image/jpg" = [ "org.gnome.loupe.desktop" ];
          "application/json" = [ "gnome-text-editor.desktop" ];
          "application/toml" = "org.gnome.TextEditor.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
        };
      };
    };
    targets.genericLinux.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "pop-shell@system76.com"
        ];
        favourite-apps = [
          "firefox.desktop"
          "Alacritty.desktop"
        ] ++ optional config.desktop.programs.discord.enable "discord.desktop";
      };
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ "disabled" ];
        toggle-message-tray = [ "disabled" ];
        close = "['<Super>q', '<Alt>F4']";
        maximize = [ "disabled" ];
        minimize = "['<Super>comma']";
        move-to-monitor-down = [ "disabled" ];
        move-to-monitor-left = [ "disabled" ];
        move-to-monitor-right = [ "disabled" ];
        move-to-monitor-up = [ "disabled" ];
        move-to-workspace-down = [ "disabled" ];
        move-to-workspace-up = [ "disabled" ];
        switch-to-workspace-left = [ "<Super>bracketleft" ];
        switch-to-workspace-right = [ "<Super>bracketright" ];
        switch-input-source = [ "disabled" ];
        switch-input-source-backward = [ "disabled" ];
        toggle-maximized = [ "<Super>Up" ];
        unmaximize = [ "disabled" ];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
        num-workspaces = 10;
      };
      "org/gnome/shell/extensions/pop-shell" = {
        focus-right = [ "disabled" ];
        tile-by-default = true;
        tile-enter = [ "disabled" ];
        activate-launcher = [ "<Super>space" ];
      };
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    };
  };
}
