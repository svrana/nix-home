{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/print-server.nix
    ../../roles/media.nix
    ../../apps/rss.nix
    ../../apps/syncthing.nix
    ../../apps/borgbase-backup.nix
    ../../apps/minecraft.nix
    ../../apps/postgres.nix
    ../../apps/immich.nix
    ../../apps/forgejo.nix
  ];

  networking = {
    hostName = "bocana";
    interfaces = {
      eno1.useDHCP = false;
      enp2s0.useDHCP = false;
      wlp4s0.useDHCP = false;
    };
  };

  services.openssh = {
    openFirewall = true;
    settings.PermitRootLogin = "yes";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  system.stateVersion = "20.09";
}
