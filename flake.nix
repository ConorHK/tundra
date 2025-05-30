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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ ];
        config = { };
      };

      mkHomeConfiguration = {
        system,
        username,
        modules ? [],
        extraModules ? []
      }: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor system;
        extraSpecialArgs = { inherit inputs; };
        modules = modules ++ extraModules;
      };
    in {
      packages = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          creeper = import ./nix/packages/creeper { inherit pkgs; };
          wallpapers = import ./nix/packages/wallpapers { inherit pkgs; };
          zellij-autolock = import ./nix/packages/zellij-autolock { inherit pkgs; };
        }
      );

      nixosModules = {
        common-role = import ./nix/modules/nixos/common-role;
        desktop = import ./nix/modules/nixos/desktop;
        desktop-role = import ./nix/modules/nixos/desktop-role;
        gaming-role = import ./nix/modules/nixos/gaming-role;
        hardware = import ./nix/modules/nixos/hardware;
        roles = import ./nix/modules/nixos/roles;
        security = import ./nix/modules/nixos/security;
        services = import ./nix/modules/nixos/services;
        styles = import ./nix/modules/nixos/styles;
        system = import ./nix/modules/nixos/system;
        user = import ./nix/modules/nixos/user;
      };

      homeModules = {
        cli = import ./nix/modules/home/cli;
        system = import ./nix/modules/home/system;
        desktop = import ./nix/modules/home/desktop;
        styles = import ./nix/modules/home/styles;
        roles = import ./nix/modules/home/roles.nix;
      };

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/hosts/desktop
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/hosts/laptop
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };

        vps = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/hosts/vps
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        "conor@desktop" = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "conor";
          modules = [
            self.homeModules.cli
            self.homeModules.system
            self.homeModules.desktop
            self.homeModules.styles
            self.homeModules.roles
            ./nix/hosts/desktop/users/conor.nix
          ];
        };

        "conor@laptop" = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "conor";
          modules = [
            self.homeModules.cli
            self.homeModules.system
            self.homeModules.desktop
            self.homeModules.styles
            self.homeModules.roles
            ./nix/hosts/laptop/users/conor.nix
          ];
        };

        "knoconor@remote-dev" = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "knoconor";
          modules = [
            self.homeModules.cli
            self.homeModules.system
            self.homeModules.desktop
            self.homeModules.styles
            self.homeModules.roles
            ./nix/hosts/remote-dev/users/knoconor.nix
          ];
        };
      };

      # Development shells
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = import ./nix/devshell.nix { inherit pkgs; };
        }
      );

      # Formatter
      formatter = forAllSystems (system:
        let pkgs = pkgsFor system;
        in pkgs.treefmt
      );
    };
}
