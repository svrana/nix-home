{ config, pkgs, ... }:

let imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
    rofi.fontSize = 12;
    dunst.fontSize = 14;
    alacritty.fontSize = 8;
    x.cursorSize = 14;
    polybar = {
      font0.size = "10;2";
      font1.size = "12;0";
      font2.size = "22;4";
      wirelessInterface = "wlp4s0";
      modules-right = "volume wlan powermenu";
    };
  };

  imports = [ ../../home ];
}
