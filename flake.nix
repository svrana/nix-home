{
  description = "svrana's NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager }:
  let
    mkOverlay = system: import ./overlay { };
  in rec {
    nixosConfigurations = let
      system-config = name: system:
      let
        myoverlay = mkOverlay system;
      in {
        "${name}" = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [ myoverlay ];
              nixpkgs.config.allowUnfree = true;
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            home-manager.nixosModules.home-manager
            { home-manager.useGlobalPkgs = true; }
            #(import (./hosts + "/${name}/default.nix"))
            (import (./hosts + "/${name}/configuration.nix"))
            (import (./hosts + "/${name}/hardware-configuration.nix"))
          ];
        };
      };
    in {}
    // (system-config "richland" "x86_64-linux")
    ;
    overlay = mkOverlay "x86_64-linux";
  };
}
