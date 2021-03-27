{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    libnotify
  ];
}
