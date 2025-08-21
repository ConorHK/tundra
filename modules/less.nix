_: {
  flake.modules.homeManager.less = {
    programs = {
      less.enable = true;
      zsh.sessionVariables = {
        LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      };
      fish.interactiveShellInit = ''
        set -x LESSHISTFILE $XDG_CACHE_HOME/less/history
      '';
    };
  };
}
