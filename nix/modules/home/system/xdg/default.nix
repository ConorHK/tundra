{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.xdg;
in
{
  options.system.xdg = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable xdg directories";
    };
    enableUserDirectories = mkOption {
      default = true;
      type = with types; bool;
      description = "enable xdg user directories";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };

    xdg = {
      enable = true;
      cacheHome = config.home.homeDirectory + "/.local/cache";
      userDirs = {
        enable = cfg.enableUserDirectories;
        createDirectories = true;

        desktop = mkDefault "${config.home.homeDirectory}/desktop";
        documents = mkDefault "${config.home.homeDirectory}/docs";
        download = mkDefault "${config.home.homeDirectory}/dl";
        music = mkDefault "${config.home.homeDirectory}/media/music";
        pictures = mkDefault "${config.home.homeDirectory}/media/pictures";
        publicShare = null;
        templates = null;
        videos = mkDefault "${config.home.homeDirectory}/media/videos";

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/media/pictures/screenshots";
          XDG_REPOSITORIES_DIR = "${config.home.homeDirectory}/repositories";
        };
      };
    };
  };
}
