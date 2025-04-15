{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.spotify;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];
  options.desktop.programs.spotify = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable spotify";
    };
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
    };
  };
}
