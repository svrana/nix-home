{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/nextcloud.nix
    ../../roles/print-server.nix
    ../../roles/syncthing.nix
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
    settings.PermitRootLogin = "yes";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  system.stateVersion = "20.09";
}
