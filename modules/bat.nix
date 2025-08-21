{
  flake.modules.homeManager.bat =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      batWithGlow = pkgs.writeShellScriptBin "bat-with-glow" ''
        if [[ $1 == *.md ]]; then
          PAGER='bat' ${pkgs.glow}/bin/glow -p "$1"
        else
          ${pkgs.bat}/bin/bat --style='plain,rule,header' --paging=never "$1"
        fi
      '';
    in
    {
      programs.bat = {
        enable = true;
        config = {
          pager = "less -FR";
        };
      };
      home.shellAliases = {
        bat = "${batWithGlow}/bin/bat-with-glow";
        cat = "bat";
      };
    };
}
