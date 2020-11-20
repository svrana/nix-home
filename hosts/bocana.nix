{ config, pkgs, ... }:

let imports = [ ../modules/settings.nix ];
in {
  config.settings = {
    rofiFontSize = 12;
    dunstFontSize = 14;
    alacrittyFontSize = 8;
    cursorSize = 14;
    polybar = {
      font0Size = "12;3";
      font1Size = "12;4";
      font2Size = "22;7";
      wirelessInterface = "wlp4s0";
    };
  };

  imports = [ ../common.nix ];
}
