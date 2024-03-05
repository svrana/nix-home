{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in
{
  config.settings = {
    waybar = {
      interfaces = "wlp3s0";
    };
  };

  imports = [ ../../home ];
}
