{ config, pkgs, ... }:

#
# elsie is a xps 13", 4k. Defaults are for 27" 4k so fonts need some help here.
#

let
  imports = [
    ../../modules/settings.nix
  ];
in
{
  config.settings = {
    i3.fonts.size = 18;
    rofi.fontSize = 18;
    dunst.fontSize = 16;
    alacritty.fontSize = 14;
    x.cursorSize = 14;
    polybar = {
      font0.size = "18;3";
      font1.size = "18;4";
      font2.size = "26;7";
      wirelessInterface = "wlp2s0";
      wiredInterface = "eno1";
      modules-right = "volume xbacklight battery wlan eth powermenu";
    };
  };

  imports = [
    ../../home
  ];
}
