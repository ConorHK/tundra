_: {
  flake.modules.homeManager.wget =
    {
      pkgs,
      ...
    }:
    {
      home = {
        packages = with pkgs; [
          wget
        ];
        shellAliases.wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
      };
    };
}
