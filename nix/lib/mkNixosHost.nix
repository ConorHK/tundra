{ self, inputs, ... }:
{
  mkNixosHost =
    {
      system ? "x86_64-linux",
      hostname,
      username ? "conor",
      stateVersion ? "25.05",
      homeDirectory ? "/home/${username}",
      additionalHomeModules ? [ ],
      additionalNixosModules ? [ ],
      additionalSpecialArgs ? { },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          hostname
          username
          self
          ;
      }
      // additionalSpecialArgs;
      modules = [
        (_: {
          nixpkgs.config = {
            allowUnfree = true;
          };
        })

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {
              inherit
                inputs
                hostname
                username
                self
                ;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username}.imports = [
              ../hosts/${hostname}/users/${username}.nix
              (_: {
                config.home = {
                  inherit username stateVersion homeDirectory;
                };
              })
            ]
            ++ additionalHomeModules;
          };
        }

        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        ../hosts/${hostname}/configuration.nix
      ]
      ++ additionalNixosModules;
    };
}
