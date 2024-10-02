{
  description = "my dots";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # 6.0.2 4680; last known working zoom w/ screen-sharing
    nixpkgs-zoom.url = "github:NixOS/nixpkgs/06031e8a5d9d5293c725a50acf0124219363502";
    spotify-cleanup = {
      url = "github:svrana/spotify-cleanup";
      #url = "git+file:///home/shaw/Projects/spotify-cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms-overlay = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , lix-module
    , flake-utils
    , deploy-rs
    , home-manager
    , neorg-overlay
    , tms-overlay
    , ... } @inputs:
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
            lix-module.nixosModules.default
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
            inputs.spotify-cleanup.homeModules.default
          ] ++ extraModules;
          extraSpecialArgs = { inherit inputs; };
        };
    in
    (
      flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            devShells.default= pkgs.mkShell {
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
              neorg-overlay = neorg-overlay.overlays.default;
              tms-overlay = tms-overlay.overlays.default;
          };

        # deploy '.#bocana'
        deploy.nodes.bocana = {
          hostname = "bocana";
          autoRollback = false;
          sshUser = "root";
          magicRollback = false;
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
