_: {
  flake.modules.homeManager.script-directory =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      programs.zsh.initContent = ''
        fpath+="${inputs.script-directory}/share/zsh/site-functions"
      '';
      home = {
        sessionVariables.SD_ROOT = "$HOME/scripts";
        sessionPath = [
          "${config.home.homeDirectory}/scripts/.scripts"
        ];
        packages = [ inputs.script-directory.packages.${pkgs.system}.sd ];
      };
    };
}
