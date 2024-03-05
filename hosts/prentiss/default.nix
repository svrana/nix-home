{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
  };

  imports = [ ../../home ];
}
