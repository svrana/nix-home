{ config, pkgs, ... }:

let
  imports = [
    ../modules/settings.nix
  ];
in
{
  # winfield has a 27" 4K display so fonts need to be adjusted to be readable.
  config.settings = {
    rofiFontSize = 12;
    dunstFontSize = 14;
    # not used yet: change manually in config/alacritty.yml
    alacrittyFontSize = 8;
    cursorSize = 16;
  };

  imports = [
    ../common.nix
  ];
}
