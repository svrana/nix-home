{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/nextcloud.nix
    ../../roles/dns-server.nix
    ../../roles/print-server.nix
  ];

  networking = {
    hostName = "bocana";
    interfaces = {
      eno1.useDHCP = false;
      enp2s0.useDHCP = false;
      wlp4s0.useDHCP = false;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "20.09";
}
