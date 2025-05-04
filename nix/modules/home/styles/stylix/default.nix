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
      targets = {
        firefox = mkIf wantFirefox {
          profileNames = [ "default" ];
        };
      };
      base16Scheme = {
        base00 = "#1c1c1c";
        base01 = "#262626";
        base02 = "#626262";
        base03 = "#878787";
        base04 = "#dfdfaf";
        base05 = "#dfdfaf";
        base06 = "#dfdfaf";
        base07 = "#dfdfaf";
        base08 = "#af5f5f";
        base09 = "#af875f";
        base0A = "#af875f";
        base0B = "#87875f";
        base0C = "#87afaf";
        base0D = "#878787";
        base0E = "#af8787";
        base0F = "#87afaf";
      };
      targets.hyprpaper.enable = mkForce false;
    };
  };
}
