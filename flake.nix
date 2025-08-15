{
  description = "Tundra - A comprehensive NixOS and Home Manager configuration system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

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
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
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
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      imports = [
        inputs.flake-parts.flakeModules.modules

        ./modules/atuin.nix
        ./modules/cnvim.nix
        ./modules/development.nix
        ./modules/git.nix
        ./modules/jq.nix
        ./modules/hosts/remote-dev.nix
      ];

      perSystem =
        { system, ... }:
        let
          flakeLib = import ./nix/lib/default.nix {
            inherit (inputs) self nixpkgs;
            inherit inputs;
          };
          pkgs = flakeLib.pkgsFor { inherit system; };

          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./nix/formatter.nix;

          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              treefmt = {
                enable = true;
                package = treefmtEval.config.build.wrapper;
              };
              flake-checker.enable = true;
            };
          };
        in
        {
          packages = {
            creeper = import ./nix/packages/creeper { inherit pkgs; };
            wallpapers = import ./nix/packages/wallpapers { inherit pkgs; };
            zellij-autolock = import ./nix/packages/zellij-autolock { inherit pkgs; };
          };

          devShells.default = pkgs.mkShell {
            inherit (pre-commit-check) shellHook;
            buildInputs =
              with pkgs;
              [
                inputs.home-manager.packages.${system}.default
                nh
                sops
                age
                ssh-to-age
                git
              ]
              ++ pre-commit-check.enabledPackages;
          };

          formatter = treefmtEval.config.build.wrapper;

          checks = {
            formatting = treefmtEval.config.build.check inputs.self;
            inherit pre-commit-check;
          };
        };

      flake =
        let
          flakeLib = import ./nix/lib/default.nix {
            inherit (inputs) self nixpkgs;
            inherit inputs;
          };
        in
        {
          lib = flakeLib;

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
                inputs.nix-index-database.hmModules.nix-index
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
                inputs.nix-index-database.hmModules.nix-index
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
          };

          homeConfigurations = {
            "mustang@venus" = flakeLib.mkHomeConfig {
              pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
              hostname = "venus";
              username = "mustang";
              additionalModules = [
                inputs.nix-index-database.hmModules.nix-index
              ];
            };
            "knoconor@remote-dev" = flakeLib.mkHomeConfig {
              pkgs = flakeLib.pkgsFor { system = "x86_64-linux"; };
              hostname = "remote-dev";
              username = "knoconor";
              additionalModules = [
                inputs.nix-index-database.hmModules.nix-index
                inputs.self.modules.homeManager.development
                inputs.self.modules.homeManager.remote-dev
              ];
            };
            "knoconor@bcd0744bec2c" = flakeLib.mkHomeConfig {
              pkgs = flakeLib.pkgsFor { system = "aarch64-darwin"; };
              hostname = "bcd0744bec2c";
              username = "knoconor";
              homeDirectory = "/Users/knoconor";
              additionalModules = [
                inputs.nix-index-database.hmModules.nix-index
                inputs.self.modules.homeManager.development
              ];
            };
          };
        };
    };
}
