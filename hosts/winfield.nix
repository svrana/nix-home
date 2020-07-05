{ config, pkgs, ... }:

let
  imports = [
    ../modules/settings.nix
  ];
in
{
  # winfield has a 27" 4K display so fonts need to be adjusted to be readable.
  config.settings = {
    dunstFontSize = 1;
    alacrittyFontSize = 14;
    cursorSize = 16;
  };

  imports = [
    ../common.nix
  ];
}
