# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/amd
    ../../roles/standard
    ../../roles/nixflix.nix
  ];

  networking.hostName = "park";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = false;

  boot.blacklistedKernelModules = [ "snd_hda_intel" ];

  services.openssh = {
    settings.PermitRootLogin = "yes";
  };

  # disable power save on this ax200 as it powers on while I'm working and speed drops to shit
  # equivalent to doing iw dev <wlp3s0> set power_save off
  networking.networkmanager.wifi.powersave = false;

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
