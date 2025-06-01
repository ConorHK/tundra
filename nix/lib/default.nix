{
  self,
  inputs,
  nixpkgs,
  ...
}:
let
  mkNixosHost = import ./mkNixosHost.nix { inherit self inputs; };
  mkHomeConfig = import ./mkHomeConfig.nix { inherit self inputs; };
  systems = import ./systems.nix { inherit nixpkgs; };
in
{
  inherit (mkNixosHost) mkNixosHost;
  inherit (mkHomeConfig) mkHomeConfig;
  inherit (systems) forAllSystems pkgsFor;
}
