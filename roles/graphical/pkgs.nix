{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    libnotify
    gnome3.adwaita-icon-theme
  ];
}
