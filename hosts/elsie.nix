{ config, pkgs, ... }:

#
# elsie is a laptop and she gets the default settings.
#

let
  imports = [
    ../modules/settings.nix
  ];
in
{
  imports = [
    ../common.nix
  ];
}
