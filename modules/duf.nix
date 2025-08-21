_: {
  flake.modules.homeManager.duf =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ duf ];
        shellAliases.df = "duf";
      };
    };
}
