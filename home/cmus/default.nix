{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    cmus
  ];

  xdg.configFile."cmus/rc".source = ./cmus.rc;

  #home.file.".local/share/applications/cmus.desktop".source = ./cmus.desktop;
}
