{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.jujutsu;
in
{
  options.cli.programs.jujutsu = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable jujutsu version control";
    };
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        ui.default_command = "log";
        user = mkDefault {
          email = "dev@conorknowles.com";
          name = "Conor Knowles";
        };
      };
    };
  };
}
