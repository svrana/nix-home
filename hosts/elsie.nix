{ config, pkgs, ... }:

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
