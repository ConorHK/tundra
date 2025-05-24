{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.shells.fish;
in
{
  options.cli.shells.fish = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable fish shell";
    };
  };
  config = mkIf cfg.enable {
    programs = {
      carapace.enable = true;
      fish = {
        enable = true;
        functions = {
          fish_greeting = "";
        };
        interactiveShellInit = ''
            # vim mode
            fish_vi_key_bindings
            set fish_cursor_default     block      blink
            set fish_cursor_insert      line       blink
            set fish_cursor_replace_one underscore blink
            set fish_cursor_visual      block

            # prompt
            set --global hydro_symbol_prompt "── ─"
            set --global hydro_symbol_ahead "↑ "
            set --global hydro_symbol_behind "↓ "
            set --global hydro_color_git magenta
            set --global hydro_color_prompt yellow
        '';
        plugins = [
          {
            name = "hydro";
            inherit (pkgs.fishPlugins.hydro) src;
          }
        ];
      };
      zsh = {
        enable = true;
        initExtra = ''
          if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
          then
            exec fish -l
          fi
        '';
      };
    };
  };
}
