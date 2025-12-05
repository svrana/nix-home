{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    libnotify
  ];

  programs.zoom-us.enable = true;
}
