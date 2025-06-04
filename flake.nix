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

    apple-fonts = {
      url = "github:lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
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
            inputs.cnvim.homeModules.default
            inputs.nix-index-database.hmModules.nix-index
            inputs.nixcord.homeModules.nixcord
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];
        };

        laptop = flakeLib.mkNixosHost {
          hostname = "laptop";
          additionalHomeModules = [
            inputs.cnvim.homeModules.default
            inputs.nix-index-database.hmModules.nix-index
            inputs.nixcord.homeModules.nixcord
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];
        };

        vps = flakeLib.mkNixosHost {
          hostname = "vps";
          username = "driver";
        };
      };

      homeConfigurations = {
        "mustang@venus" = flakeLib.mkHomeConfig {
          pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
          hostname = "venus";
          username = "mustang";
          additionalModules = [
            inputs.cnvim.homeModules.default
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
        "knoconor@remote-dev" = flakeLib.mkHomeConfig {
          pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
          hostname = "remote-dev";
          username = "knoconor";
          additionalModules = [
            inputs.cnvim.homeModules.default
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
      };

      devShells = flakeLib.forAllSystems supportedSystems (
        system:
        let
          pkgs = flakeLib.pkgsFor { inherit system; };
        in
        {
          default = import ./nix/devshell.nix { inherit pkgs; };
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
