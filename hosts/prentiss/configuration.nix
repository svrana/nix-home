# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/intel
    ../../roles/standard
    ../../roles/graphical
    ../../roles/work
    ../../roles/virtualization.nix
    ../../roles/elastic-search.nix
  ];

  networking.hostName = "prentiss";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  programs.dconf.enable = true;

  system.stateVersion = "21.05";
}
