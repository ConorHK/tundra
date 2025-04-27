{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.vintagestory;
in
{
  options.desktop.programs.vintagestory = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "install vintagestory";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vintagestory
    ];

    nixpkgs.config.permittedInsecurePackages = [  # TODO: this wont work
      "dotnet-runtime-7.0.20"
    ];
  };
}
