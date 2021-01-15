{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
    rofi.fontSize = 12;
    dunst.fontSize = 12;
    alacritty.fontSize = 8;
    x.cursorSize = 14;
    polybar = {
      font0.size = "10;2";
      font1.size = "12;0";
      font2.size = "22;4";
      wirelessInterface = "wlp0s20f3";
      wiredInterface = "eno1";
      modules-right = "volume wlan eth powermenu";
    };
  };

  imports = [ ../../home ];
}
