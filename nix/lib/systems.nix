{ nixpkgs, ... }:
{
  forAllSystems = supportedSystems: nixpkgs.lib.genAttrs supportedSystems;
  pkgsFor =
    {
      system,
      overlays ? [ ],
      allowUnfree ? true,
    }:
    import nixpkgs {
      inherit system overlays;
      config.allowUnfree = allowUnfree;
    };
}
