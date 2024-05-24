{
  description = "my dots";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, deploy-rs, home-manager, ... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem;
      inherit (builtins) readDir mapAttrs;
      lib = nixpkgs.lib;
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkgs: true);
        };
        overlays = builtins.attrValues self.overlays;
      };

      mkSystem = extraModules: nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${lib.substring 0 7 self.sourceInfo.rev} - \\l >>>";
            })
            { nixpkgs.overlays = nixpkgsConfig.overlays; }
          ] ++ extraModules;
        };

      mkHome = extraModules: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            inherit (nixpkgsConfig) config overlays;
          };
          modules = [
            modules/my.nix
            inputs.wayland-pipewire-idle-inhibit.homeModules.default
          ] ++ extraModules;
          extraSpecialArgs = inputs;
        };
    in
    (
      flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            devShell = pkgs.mkShell {
              name = "dots";
              buildInputs = [
                deploy-rs.packages.${system}.deploy-rs
                (import home-manager { inherit pkgs; }).home-manager
              ];
            };
          })
      //
      {
        nixosConfigurations = {
          prentiss = mkSystem [ ./hosts/prentiss/configuration.nix ];
          bocana = mkSystem [ ./hosts/bocana/configuration.nix ];
          park = mkSystem [ ./hosts/park/configuration.nix ];
        };

        homeConfigurations = {
          prentiss = mkHome [ ./hosts/prentiss ];
          park = mkHome [ ./hosts/park ];
        };

        overlays = with lib;
          let
            overlayFiles' = filter (hasSuffix ".nix") (attrNames (readDir ./overlays));
            overlayFiles = listToAttrs (map
              (name: {
                name = removeSuffix ".nix" name;
                value = import (./overlays + "/${name}");
              })
              overlayFiles');
          in
          overlayFiles // {
          };

        # deploy '.#bocana'
        deploy.nodes.bocana = {
          hostname = "bocana";
          autoRollback = false;
          sshUser = "root";
          fastConnection = true;
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bocana;
          };
        };

        # This is highly advised, and will prevent many possible mistakes
        checks = mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      }
    );
}
