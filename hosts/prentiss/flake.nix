{
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.prentiss = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
