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

    xdg = {
      mime.enable = true;
      systemDirs.data = [
        "${config.home.homeDirectory}/.nix-profile/share/applications"
        "${config.home.homeDirectory}/state/nix/profile/share/applications"
      ];
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
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        activate-launcher = [ "<Super>space" ];
      };
      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
      };
      "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    };
  };
}
