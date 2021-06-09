{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./docker.nix
    # not until we have a flake
    #./home.nix
    ./plymouth.nix
    ./pkgs.nix
    ./printing.nix
    ./sound.nix
    ./x.nix
  ];

  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ]; # fixes pinentry-gnome3 from working on none-Gnome systems.

  documentation.dev.enable = true;
}
