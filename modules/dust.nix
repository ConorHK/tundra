_: {
  flake.modules.homeManager.dust =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [ du-dust ];
        shellAliases.du = "dust";
      };
    };
}
