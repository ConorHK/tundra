{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.discord;
in
{
  options.desktop.programs.discord = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable discord voicechat";
    };
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };
    xdg = {
      mimeApps = {
        defaultApplications = {
          "x-scheme-handler/discord" = [ "discord.desktop" ];
        };
      };
    };
  };
}
