{ config, pkgs, ... }:

{
  imports = [
    ../modules/settings.nix
  ];

  settings = {
    alacrittyFontSize = 14;
    dunstFontSize = 14;
    rofiFontSize = 12;
    polybarFontSize = 12;
    xorgConfig = "xorg.conf.winfield";
  };
}

