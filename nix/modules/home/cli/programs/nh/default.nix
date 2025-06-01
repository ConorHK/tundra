{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.nh;
in
{
  options.cli.programs.nh = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable nix cli helper";
    };
  };

  config = mkIf cfg.enable {
    programs.nh.enable = true;
    home.sessionVariables.NH_NO_CHECKS = "true"; # required for determinate nix use
  };
}
