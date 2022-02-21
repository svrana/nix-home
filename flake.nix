{
  description = "my dots";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

  outputs = { self, nixpkgs, flake-utils, deploy-rs, ... }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = builtins.attrValues self.overlays;
      };
      specialArgs = { inherit inputs; };
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
                deploy-rs.packages.x86_64-linux.deploy-rs

                (import inputs.home-manager { inherit pkgs; }).home-manager

                (pkgs.writeShellScriptBin "nixos-rebuild-pretty" ''
                  sudo -E sh -c "nixos-rebuild switch --flake ."
                  # sudo -E sh -c "nixos-rebuild --install-bootloader --flake ."
                '')

                (pkgs.writeShellScriptBin "hm-prentiss" ''
                  home-manager switch --flake '.#prentiss'
                '')
                (pkgs.writeShellScriptBin "hm-park" ''
                  home-manager switch --flake '.#park'
                '')
                (pkgs.writeShellScriptBin "hm-elsie" ''
                  home-manager switch --flake '.#elsie'
                '')
              ];
              #NIX_PATH = builtins.concatStringsSep ":" [
              #  "nixpkgs=${inputs.nixpkgs}"
              #"home-manager=${inputs.home-manager}"
              #];
            };
          })
      //
      {
        nixosConfigurations = {
          prentiss = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/prentiss/configuration.nix ];
            specialArgs = specialArgs;
          };
          bocana = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/bocana/configuration.nix ];
            specialArgs = specialArgs;
          };
          elsie = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/elsie/configuration.nix ];
            specialArgs = specialArgs;
          };
          park = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/park/configuration.nix ];
            specialArgs = specialArgs;
          };
        };

        homeConfigurations = {
          prentiss = inputs.home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            username = "shaw";
            homeDirectory = "/home/${username}";
            extraSpecialArgs = specialArgs;
            stateVersion = "21.03";
            configuration = { ... }: {
              imports = [ ./hosts/prentiss ];
              nixpkgs = nixpkgsConfig;
            };
          };
          park = inputs.home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            username = "shaw";
            homeDirectory = "/home/${username}";
            extraSpecialArgs = specialArgs;
            stateVersion = "21.03";
            configuration = { ... }: {
              imports = [ ./hosts/park ];
              nixpkgs = nixpkgsConfig;
            };
          };
          elsie = inputs.home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            username = "shaw";
            homeDirectory = "/home/${username}";
            extraSpecialArgs = specialArgs;
            stateVersion = "21.03";
            configuration = { ... }: {
              imports = [ ./hosts/elsie ];
              nixpkgs = nixpkgsConfig;
            };
          };
        };

        overlays = with lib;
          let
            overlayFiles' = filter (hasSuffix ".nix") (attrNames (builtins.readDir ./overlays));
            overlayFiles = listToAttrs (map
              (name: {
                name = lib.removeSuffix ".nix" name;
                value = import (./overlays + "/${name}");
              })
              overlayFiles');
          in
          overlayFiles // {
            discord-overlay = inputs.discord-overlay.overlay;
          };

        # deploy-rs doesn't like overlays above :( (missing `final` argument) ..
        #
        # deploy '.#bocana'
        deploy.nodes.bocana = {
          hostname = "bocana";
          sshUser = "root";
          fastConnection = true;
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bocana;
          };
        };

        # This is highly advised, and will prevent many possible mistakes
        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      }
    );
}

