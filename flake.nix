{
  description = "Tundra - A comprehensive NixOS and Home Manager configuration system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma.url = "github:nix-community/comma";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cnvim = {
      url = "github:conorhk/vimrc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    script-directory = {
      url = "github:conorhk/sd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    lanzaboote.url = "github:nix-community/lanzaboote";
    impermanence.url = "github:nix-community/impermanence";

    nixcord.url = "github:kaylorben/nixcord";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ ];
          config.allowUnfree = true;
        };
      mkHomeConfiguration =
        {
          system,
          modules ? [ ],
          extraModules ? [ ],
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = { inherit inputs; };
          modules = modules ++ extraModules;
        };
      treefmtEval = forAllSystems (
        system: treefmt-nix.lib.evalModule (pkgsFor system) ./nix/formatter.nix
      );
      mkHost =
        {
          system,
          stateVersion,
          pkgs,
          imports ? [ ],
          modules ? [ ],
          specialArgs ? { },
          specialHomeArgs ? { },
          homes ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            {
              system.stateVersion = stateVersion;
              nixpkgs.pkgs = pkgs;
              inherit imports;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialHomeArgs;
              home-manager.users = homes;
            }
          ] ++ modules;
        };

      mkHome =
        {
          username,
          homeDirectory ? if username == "root" then "/root" else "/home/${username}",
          stateVersion,
          imports ? [ ],
        }:
        {
          home = {
            inherit username stateVersion homeDirectory;
          };
          nix.registry = {
            self.flake = self;
            nixpkgs.flake = nixpkgs;
          };
          inherit imports;
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          creeper = import ./nix/packages/creeper { inherit pkgs; };
          wallpapers = import ./nix/packages/wallpapers { inherit pkgs; };
          zellij-autolock = import ./nix/packages/zellij-autolock { inherit pkgs; };
        }
      );

      # nixosModules = {
      #   common-role = import ./nix/modules/nixos/common-role;
      #   desktop = import ./nix/modules/nixos/desktop;
      #   desktop-role = import ./nix/modules/nixos/desktop-role;
      #   gaming-role = import ./nix/modules/nixos/gaming-role;
      #   hardware = import ./nix/modules/nixos/hardware;
      #   roles = import ./nix/modules/nixos/roles;
      #   security = import ./nix/modules/nixos/security;
      #   services = import ./nix/modules/nixos/services;
      #   styles = import ./nix/modules/nixos/styles;
      #   system = import ./nix/modules/nixos/system;
      #   user = import ./nix/modules/nixos/user;
      # };
      #
      # homeModules = {
      #   cli = import ./nix/modules/home/cli;
      #   system = import ./nix/modules/home/system;
      #   desktop = import ./nix/modules/home/desktop;
      #   styles = import ./nix/modules/home/styles;
      #   roles = import ./nix/modules/home/roles.nix;
      # };

      nixosConfigurations = {
        desktop =
          let
            stateVersion = "25.05";
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialHomeArgs = inputs;
          in
          mkHost {
            inherit
              system
              stateVersion
              pkgs
              specialHomeArgs
              ;
            imports = [
              ./nix/hosts/desktop/configuration.nix
            ];
            homes = {
              "conor" = mkHome {
                inherit stateVersion;
                username = "conor";
                imports = [
                  ./nix/hosts/desktop/users/conor.nix
                  inputs.cnvim.homeModule
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.nixcord.homeModules.nixcord
                  inputs.spicetify-nix.homeManagerModules.spicetify
                ];
              };
            };
            specialArgs = { inherit inputs; };
          };

        laptop =
          let
            stateVersion = "25.05";
            system = "x86_64-linux";
            pkgs = pkgsFor system;
            specialHomeArgs = inputs;
          in
          mkHost {
            inherit
              system
              stateVersion
              pkgs
              specialHomeArgs
              ;
            imports = [
              ./nix/hosts/laptop/configuration.nix
            ];
            homes = {
              "conor" = mkHome {
                inherit stateVersion;
                username = "conor";
                imports = [
                  ./nix/hosts/laptop/users/conor.nix
                  inputs.cnvim.homeModule
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.nixcord.homeModules.nixcord
                  inputs.spicetify-nix.homeManagerModules.spicetify
                ];
              };
            };
            specialArgs = { inherit inputs; };
          };

        vps =
          let
            stateVersion = "25.05";
            system = "x86_64-linux";
            pkgs = pkgsFor system;
          in
          mkHost {
            inherit system stateVersion pkgs;
            imports = [
              ./nix/hosts/vps/configuration.nix
            ];
            specialArgs = { inherit inputs; };
          };
      };

      homeConfigurations = {
        "mustang@venus" = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "mustang";
          modules = [
            ./nix/hosts/venus/users/mustang.nix
          ];
        };
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = import ./nix/devshell.nix { inherit pkgs; };
        }
      );

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });

    };
}
