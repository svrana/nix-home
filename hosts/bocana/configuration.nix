# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/nextcloud.nix
    ../../roles/print-server.nix
  ];

  networking.hostName = "bocana";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # add to host file here so it works for entire network...since bocana is our
  # dns server.
  networking.extraHosts = ''
    192.168.7.170 brother
  '';

  system.stateVersion = "20.09";

  ## adguard home
  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [
      80 # nextcloud
      53 # dns / adguard
    ];
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };
}
