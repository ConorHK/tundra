{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.rofi;
in
{
  options.desktop.programs.rofi =  {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable rofi";
    };
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = mkDefault pkgs.rofi-wayland;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      extraConfig = {
        modi = "run,drun,window";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯  Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
