# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/graphical
  ];

  networking.hostName = "bocana";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  system.stateVersion = "20.09";

  ## adguard home
  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [
      53    # dns / adguard
      631   # cups server
    ];
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };
}
