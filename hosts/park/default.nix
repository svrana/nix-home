{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in
{
  config.settings = {
    waybar = {
      interfaces = "wlp3s0";
    };
    polybar = {
      wirelessInterface = "wlp3s0";
      wiredInterface = "eno1";
      modules-right = "volume wlan eth powermenu";
    };
  };

  imports = [ ../../home ];
}
