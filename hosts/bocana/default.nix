{ config, pkgs, ... }:

let imports = [ ../../modules/settings.nix ];
in {
  config.settings = {
    polybar = {
      wirelessInterface = "wlp4s0";
      modules-right = "volume wlan powermenu";
    };
  };

  imports = [ ../../home ];
}
