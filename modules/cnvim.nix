{ inputs, ... }:
{
  flake.modules.homeManager.development =
    { pkgs, ... }:
    {
      home.sessionVariables.EDITOR = "nvim";
      home.packages = [ inputs.cnvim.packages.${pkgs.system}.nightly ];
      home.shellAliases.vim = "nvim";
    };
}
