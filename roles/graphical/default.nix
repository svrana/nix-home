{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./docker.nix
    # not until we have a flake
    #./home.nix
    ./plymouth.nix
    ./printing.nix
    ./sound.nix
    ./x.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
    gnome3.adwaita-icon-theme
  ];

  programs.dconf.enable = true;

  # enabling for standard-notes which uses libsecret
  services.gnome3.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ]; # fixes pinentry-gnome3 from working on none-Gnome systems.
}
