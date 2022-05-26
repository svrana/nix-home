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
    deploy-rs.url = "github:serokell/deploy-rs";
    discord-overlay = {
      url = "github:InternetUnexplorer/discord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, deploy-rs, home-manager, discord-overlay, ... }@inputs:
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
      specialArgs = { inherit inputs; };

      mkSystem = extraModules:
        nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${lib.substring 0 7 self.sourceInfo.rev} - \\l >>>";
            })
            { nixpkgs.overlays = nixpkgsConfig.overlays; }
          ] ++ extraModules;
          specialArgs.inputs = inputs;
        };

      mkHome = extraModules:
        home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          username = "shaw";
          homeDirectory = "/home/${username}";
          extraSpecialArgs = specialArgs;
          stateVersion = "21.03";
          configuration = { ... }: {
            imports = extraModules;
            nixpkgs = nixpkgsConfig;
          };
        };
    in
    (
      flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            devShell = pkgs.mkShell rec {
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
          elsie = mkSystem [ ./hosts/elsie/configuration.nix ];
          park = mkSystem [ ./hosts/park/configuration.nix ];
        };

        homeConfigurations = {
          prentiss = mkHome [ ./hosts/prentiss ];
          park = mkHome [ ./hosts/park ];
          elsie = mkHome [ ./hosts/elsie ];
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
            discord-overlay = discord-overlay.overlay;
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

