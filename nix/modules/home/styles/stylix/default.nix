{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.styles.stylix;
  haveDesktop = builtins.hasAttr "desktop" config;
  wantFirefox = haveDesktop && config.desktop.programs.firefox.enable;
in
with lib;
{
  options.styles.stylix = {
    enableHome = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix for all";
    };
  };

  config = mkIf cfg.enableHome {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.symbols-only
      open-sans
    ];

    stylix = {
      enable = true;
      autoEnable = true;
      enableReleaseChecks = false;
      targets = {
        firefox = mkIf wantFirefox {
          profileNames = [ "default" ];

        };
        zellij.enable = false;
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-forest.yaml";
      targets.hyprpaper.enable = mkForce false;
    };
  };
}
