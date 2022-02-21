{
  description = "A basic flake with a shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
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
              #nativeBuildInputs = [ pkgs.bashInteractive ];
              buildInputs = [
                (import inputs.home-manager { inherit pkgs; }).home-manager

                (pkgs.writeShellScriptBin "nixos-rebuild-pretty" ''
                  sudo -E sh -c "nixos-rebuild $@"
                  # sudo -E sh -c "nixos-rebuild --install-bootloader $@"
                '')

                (pkgs.writeShellScriptBin "hm-prentiss" ''
                  home-manager switch --flake '.#prentiss'
                '')

              ];
              NIX_PATH = builtins.concatStringsSep ":" [
                "nixpkgs=${inputs.nixpkgs}"
                "home-manager=${inputs.home-manager}"
              ];
            };
          })
      //
      {
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
        };
      }
    );
}

