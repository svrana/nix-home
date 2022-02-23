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
      eno1.useDHCP = true;
      enp2s0.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  system.stateVersion = "20.09";
}
