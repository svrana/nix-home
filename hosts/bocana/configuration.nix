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
    ../../apps/paperless.nix
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

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "20.09";
}
