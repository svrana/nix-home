{ config, pkgs, ... }:

let
  imports = [
    ../modules/settings.nix
  ];
in
{
  config.settings = {
    dunstFontSize = 1;
    alacrittyFontSize = 14;
  };

  imports = [
    ../common.nix
  ];
}
