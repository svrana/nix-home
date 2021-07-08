{ config, pkgs, ... }:

let
  imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
    polybar = {
      wirelessInterface = "wlp0s20f3";
      wiredInterface = "eno1";
      modules-right = "volume wlan eth powermenu";
    };
  };

  imports = [ ../../home ];
}
