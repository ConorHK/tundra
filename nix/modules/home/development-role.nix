{
  config,
  lib,
  ...
}:
let
  cfg = config.roles.home.development;
in
with lib;
{
  options.roles.home.development = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable development role";
    };
  };
  config = mkIf cfg.enable {
  };
}
