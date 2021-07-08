{
  # Configuration for the network in general.
  network = {
    description = "vnet";
  };

  # This specifies the configuration for `ryuko` as a NixOS module.
  "bocana" = { config, pkgs, lib, ... }: {
    imports = [
      ../../hosts/bocana/configuration.nix
    ];

    # The user you will SSH into the machine as. This defaults to your current
    # username, however for this example we will just SSH in as root.
    #deployment.targetUser = "root";
    deployment.targetHost = "bocana";
  };
}
