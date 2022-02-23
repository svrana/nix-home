{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./docker.nix
    ./plymouth.nix
    ./pkgs.nix
    ../print-client.nix
    ./sound.nix
    ./x.nix
  ];

  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ]; # fixes pinentry-gnome3 from working on none-Gnome systems.

  documentation.dev.enable = true;
}
