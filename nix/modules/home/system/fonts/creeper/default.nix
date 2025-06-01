{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.fonts.creeper;
in
with lib;
{
  options.system.fonts.creeper = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable creeper mono bitmap font";
    };
  };

  config = mkIf cfg.enable {
    system.fonts = {
      monospace = "creeper";
      monospaceFallback = "Unifont";
    };

    home.packages = [
      inputs.self.packages.${pkgs.system}.creeper
      unifont
    ];
  };
}
