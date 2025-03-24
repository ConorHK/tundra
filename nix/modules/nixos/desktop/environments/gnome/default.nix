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
    services = {
      xserver = {
        enable = true;
        displayManager = {
          gdm.enable = true;
        };
        desktopManager.gnome = {
          enable = true;
          extraGSettingsOverridePackages = [
            pkgs.nautilus-open-any-terminal
          ];
        };
      };
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };
    # environment.systemPackage = with pkgs; 
    #   [
    #     gnomeExtensions.pop-shell 
    #   ];
    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      cheese
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ];

    programs.dconf.enable = true;
  };
}
