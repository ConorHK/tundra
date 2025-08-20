{
  description = "Tundra - A comprehensive NixOS and Home Manager configuration system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
      flakeLib = import ./nix/lib/default.nix { inherit self inputs nixpkgs; };

      treefmtEval = flakeLib.forAllSystems supportedSystems (
        system: treefmt-nix.lib.evalModule (flakeLib.pkgsFor { inherit system; }) ./nix/formatter.nix
      );

    in
    {
      lib = flakeLib;

      packages = flakeLib.forAllSystems supportedSystems (
        system:
        let
          pkgs = flakeLib.pkgsFor { inherit system; };
        in
        {
          creeper = import ./nix/packages/creeper { inherit pkgs; };
          wallpapers = import ./nix/packages/wallpapers { inherit pkgs; };
          zellij-autolock = import ./nix/packages/zellij-autolock { inherit pkgs; };
          iso = inputs.nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            format = "install-iso";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./nix/images/iso.nix
              {
                system.stateVersion = "25.05";
              }
            ];
          };
        }
      );

      homeModules = {
        common-role = import ./nix/modules/home/common-role.nix;
        development-role = import ./nix/modules/home/development-role.nix;
      };

      nixosConfigurations = {
        desktop = flakeLib.mkNixosHost {
          hostname = "desktop";
          additionalNixosModules = [
            inputs.determinate.nixosModules.default
          ];
          additionalHomeModules = [
            inputs.nix-index-database.homeModules.nix-index
            inputs.nixcord.homeModules.nixcord
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.textfox.homeManagerModules.default
          ];
        };

        laptop = flakeLib.mkNixosHost {
          hostname = "laptop";
          additionalNixosModules = [
            inputs.determinate.nixosModules.default
          ];
          additionalHomeModules = [
            inputs.nix-index-database.homeModules.nix-index
            inputs.nixcord.homeModules.nixcord
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.textfox.homeManagerModules.default
          ];
        };

        vps = flakeLib.mkNixosHost {
          hostname = "vps";
          username = "driver";
          additionalNixosModules = [
            inputs.determinate.nixosModules.default
          ];
        };

        satelite = flakeLib.mkNixosHost {
          hostname = "satelite";
          username = "driver";
          additionalNixosModules = [
            inputs.determinate.nixosModules.default
          ];
        };

        homebox = flakeLib.mkNixosHost {
          hostname = "homebox";
          username = "driver";
          additionalNixosModules = [
            inputs.determinate.nixosModules.default
          ];
        };

      };

      homeConfigurations = {
        "mustang@venus" = flakeLib.mkHomeConfig {
          pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
          hostname = "venus";
          username = "mustang";
          additionalModules = [
            inputs.nix-index-database.homeModules.nix-index
          ];
        };
        "knoconor@remote-dev" = flakeLib.mkHomeConfig {
          pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
          hostname = "remote-dev";
          username = "knoconor";
          additionalModules = [
            inputs.nix-index-database.homeModules.nix-index
          ];
        };
        "knoconor@bcd0744bec2c" = flakeLib.mkHomeConfig {
          pkgs = flakeLib.pkgsFor { system = "aarch64-darwin"; };
          hostname = "bcd0744bec2c";
          username = "knoconor";
          homeDirectory = "/Users/knoconor";
          additionalModules = [
            inputs.nix-index-database.homeModules.nix-index
          ];
        };
      };

      devShells = flakeLib.forAllSystems supportedSystems (
        system:
        let
          pkgs = flakeLib.pkgsFor { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              home-manager
              nh
              sops
              age
              ssh-to-age
              git
            ];
          };
        }
      );

      formatter = flakeLib.forAllSystems supportedSystems (
        system: treefmtEval.${system}.config.build.wrapper
      );

      checks = flakeLib.forAllSystems supportedSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
