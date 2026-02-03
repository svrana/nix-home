{
  description = "my dots";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spotify-cleanup = {
      url = "github:svrana/spotify-cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          name = "dots";
          buildInputs = [
            inputs.deploy-rs.packages.${system}.deploy-rs
            (import inputs.home-manager { inherit pkgs; }).home-manager
          ];
        };
      };

      flake = let
        inherit (inputs.nixpkgs.lib) nixosSystem;
        lib = inputs.nixpkgs.lib;

        nixpkgsConfig = {
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = builtins.attrValues self.overlays;
        };

        mkSystem = extraModules:
          nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              { nixpkgs.overlays = nixpkgsConfig.overlays; }
              inputs.sops-nix.nixosModules.sops
              inputs.nixflix.nixosModules.nixflix
            ] ++ extraModules;
          };

        mkHome = extraModules:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {
              system = "x86_64-linux";
              inherit (nixpkgsConfig) config overlays;
            };
            modules = [
              ./modules/my.nix
              inputs.wayland-pipewire-idle-inhibit.homeModules.default
              inputs.spotify-cleanup.homeModules.default
              inputs.sops-nix.homeManagerModules.sops
            ] ++ extraModules;
            extraSpecialArgs = { inherit inputs; };
          };
      in {
        nixosConfigurations = {
          prentiss = mkSystem [ ./hosts/prentiss/configuration.nix ];
          bocana   = mkSystem [ ./hosts/bocana/configuration.nix ];
          park     = mkSystem [ ./hosts/park/configuration.nix ];
        };

        homeConfigurations = {
          prentiss = mkHome [ ./hosts/prentiss ];
        };

        overlays = with lib;
          let
            overlayFiles' =
              filter (hasSuffix ".nix") (attrNames (builtins.readDir ./overlays));

            overlayFiles =
              listToAttrs (map
                (name: {
                  name = removeSuffix ".nix" name;
                  value = import (./overlays + "/${name}");
                })
                overlayFiles');
          in
          overlayFiles // {
            neorg-overlay = inputs.neorg-overlay.overlays.default;
          };

        deploy.nodes.bocana = {
          hostname = "bocana";
          autoRollback = false;
          sshUser = "root";
          magicRollback = false;
          fastConnection = true;

          profiles.system = {
            user = "root";
            path =
              inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.bocana;
          };
        };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
      };
    };
}
