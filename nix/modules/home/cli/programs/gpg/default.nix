{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.programs.gpg;
in
{
  options.cli.programs.gpg = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable GNU privacy guard";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gpg.enable = true;
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
