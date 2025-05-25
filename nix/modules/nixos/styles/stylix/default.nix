{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.styles.stylix;
in
with lib;
{
  imports = with inputs; [
    stylix.nixosModules.stylix
  ];

  options.styles.stylix = {
    enableNixOs = mkOption {
      default = false;
      type = with types; bool;
      description = "enable stylix";
    };
  };

  config = mkIf cfg.enableNixOs {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      fontconfig = {
        enable = true;
        useEmbeddedBitmaps = true;

        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <!-- Add Symbols Nerd Font as a global fallback -->
            <match target="pattern">
              <test name="family" compare="not_eq">
                <string>Symbols Nerd Font</string>
              </test>
              <edit name="family" mode="append">
                <string>Symbols Nerd Font</string>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;
      enableReleaseChecks = false;
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

      targets.plymouth.enable = false;

      image = config.lib.stylix.pixel "base00";
      cursor = {
        name = "Quintom_Ink";
        package = pkgs.quintom-cursor-theme;
        size = 20;
      };

      fonts = {
        sizes = {
          terminal = 10;
          applications = 12;
          popups = 12;
        };

        serif = {
          package = pkgs.ubuntu_font_family;
          name = "Ubuntu";
        };
        sansSerif = {
          package = pkgs.ubuntu_font_family;
          name = "Ubuntu";
        };
        monospace = {
          package = inputs.self.packages.${pkgs.system}.creeper;
          name = "Creeper";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
