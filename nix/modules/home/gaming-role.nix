{
  config,
  flake,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.roles.home.gaming;
in
with lib;
{
  imports = [
    flake.homeModules.desktop
  ];
  options.roles.home.gaming = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable gaming role";
    };
  };
  config = mkIf cfg.enable {
    desktop.programs.discord.enable = true;

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        cpu_load_change = true;
        no_display = true;
        blacklist = [
          "nautilus"
          "ptyxis"
          "gnome"
          "text"
          "editor"
          "gnome"
          "system"
          "monitor"
          "gnome"
          "software"
          "gnome"
          "calculator"
          "gnome"
          "calendar"
          "simple"
          "scan"
          "gnome"
          "contacts"
          "gnome"
          "control"
          "center"
          "gnome"
          "clocks"
          "snapshot"
          "gnome"
          "maps"
          "gnome"
          "weather"
          "baobab"
          "loupe"
          "gnome"
          "tour"
          "gnome"
          "logs"
          "gnome"
          "characters"
          "gnome"
          "font"
          "viewer"
          "video"
          "downloader"
          "foliate"
          "xdg"
          "desktop"
          "portal"
          "gtk"
          "xdg"
          "desktop"
          "portal"
          "gnome"
          "xdg"
          "desktop"
          "portal"
          "xdg"
          "permission"
          "store"
          "xdg"
          "document"
          "portal"
        ];
      };
    };

    home.packages = with pkgs; [
      lutris
      bottles
    ];
  };
}
