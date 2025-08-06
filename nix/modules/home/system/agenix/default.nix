{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.system.agenix;
in
{
  options.system.agenix = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable agenix secret management";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.agenix.packages.${system}.default
    ];
  };
}
