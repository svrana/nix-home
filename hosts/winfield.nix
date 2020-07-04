{ config, pkgs, ... }:

let
  imports = [
    ../modules/settings.nix
  ];
in
{
  config.settings = {
    dunstFontSize = 1;
  };

  imports = [
    ../common.nix
  ];
}
