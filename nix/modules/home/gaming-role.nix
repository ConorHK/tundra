{
  flake,
  pkgs,
  ...
}:
{
  desktop.programs.discord.enable = true;
  imports = [
    flake.homeModules.desktop
  ];

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
    vintagestory # TODO: move
  ];
}
