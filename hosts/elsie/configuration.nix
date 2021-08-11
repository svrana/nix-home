# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs;
in
{
  imports = [
    ./hardware-configuration.nix
    (sources.nixos-hardware + "/dell/xps/13-9370")
    # Include the results of the hardware scan.
    ../../arch/intel
    ../../roles/standard
    ../../roles/graphical
  ];

  networking.hostName = "elsie";
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  system.stateVersion = "21.05";
}
