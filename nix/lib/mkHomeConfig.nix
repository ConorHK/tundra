{ self, inputs, ... }:
{
  mkHomeConfig =
    {
      hostname,
      username ? "conor",
      stateVersion ? "25.05",
      homeDirectory ? "/home/${username}",
      additionalModules ? { },
      additionalSpecialArgs ? { },
      pkgs,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit
          self
          inputs
          hostname
          username
          ;
      }
      // additionalSpecialArgs;
      modules = [
        ../hosts/${hostname}/users/${username}.nix
        {
          home = {
            inherit username stateVersion homeDirectory;
          };
          nix.package = pkgs.nix;
        }
        inputs.sops-nix.homeManagerModules.sops
      ]
      ++ additionalModules;
    };
}
