{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
    rofiFontSize = 12;
    dunstFontSize = 12;
    alacrittyFontSize = 8;
    cursorSize = 14;
    polybar = {
      font0Size = "10;2";
      font1Size = "12;0";
      font2Size = "22;4";
      wirelessInterface = "wlp0s20f3";
      wiredInterface = "eno1";
    };
  };

  imports = [ ../../home ];
}
