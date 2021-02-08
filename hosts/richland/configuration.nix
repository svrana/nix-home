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
  ];

  networking.hostName = "richland";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  programs.dconf.enable = true;

  # Set the default card used by pa, appending to /etc/pulse/default.pa
  # The values with:
  # > pactl list cards
  # Card #0
  #       Name: alsa_card.usb-Vanatoo_Vanatoo_T0-00
  #       Driver: module-alsa-card.c
  #       Owner Module: 6
  #       Properties:
  #               alsa.card = "2"
  #               alsa.card_name = "Vanatoo T0"
  #               alsa.long_card_name = "Vanatoo Vanatoo T0 at usb-0000:00:14.0-2, full speed"
  #               alsa.driver_name = "snd_usb_audio"
  #               device.bus_path = "pci-0000:00:14.0-usb-0:2:1.0"
  #               sysfs.path = "/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/sound/card2"
  #               udev.id = "usb-Vanatoo_Vanatoo_T0-00"
  #               device.bus = "usb"
  #               device.vendor.id = "0d8c"
  #               device.vendor.name = "C-Media Electronics, Inc."
  #               device.product.id = "0012"
  #               device.product.name = "Vanatoo T0"
  #               device.serial = "Vanatoo_Vanatoo_T0"
  #               device.string = "2"
  #               device.description = "Vanatoo T0"
  #               module-udev-detect.discovered = "1"
  #               device.icon_name = "audio-card-usb"
  #       Profiles:
  #               output:analog-stereo: Analog Stereo Output (sinks: 1, sources: 0, priority: 6500, available: yes)
  #               output:iec958-stereo: Digital Stereo (IEC958) Output (sinks: 1, sources: 0, priority: 5500, available: yes)
  #               off: Off (sinks: 0, sources: 0, priority: 0, available: yes)
  #       Active Profile: output:iec958-stereo
  #       Ports:
  #               analog-output: Analog Output (priority: 9900, latency offset: 0 usec)
  #                       Part of profile(s): output:analog-stereo
  #               iec958-stereo-output: Digital Output (S/PDIF) (priority: 0, latency offset: 0 usec)
  #                       Part of profile(s): output:iec958-stereo
  # restart pulseaudio with pulseaudio -k
  hardware.pulseaudio.extraConfig = ''
    set-card-profile alsa_card.usb-Vanatoo_Vanatoo_T0-00 output:iec958-stereo
  '';
  # still deafaults to onboard audio, .maybe b/c the above speakers go into low power mode?
  # hack hack
  boot.blacklistedKernelModules = [ "snd_hda_intel" ];
}
