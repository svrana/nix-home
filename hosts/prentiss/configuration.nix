# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/intel
    ../../roles/standard
    ../../roles/graphical
    ../../roles/work
    ../../roles/android-dev.nix
  ];

  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];
  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  networking.hostName = "prentiss";

  networking.useDHCP = false;
  # using network manager which uses it's own dhcp client so do not need to startup dhcpcd here. Doing so
  # results in two ip addresses for the same interfaces, which isn't horrible but can make it harder to configure
  # firewalls, routers, etc.
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = false;

  programs.dconf.enable = true;

  system.stateVersion = "21.05";
}
