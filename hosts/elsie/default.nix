{ config, pkgs, ... }:

#
# elsie is a xps 13", 4k. Defaults are for 27" 4k. I chose to increase font-size instead of
# scaling. Not sure what the support for fractional scaling is at this point, but that would
# be cleaner.
#
let
  imports = [ ../../modules/settings.nix ];
in
{
  config.settings = {
    i3.fonts.size = 18.0;
    rofi.fontSize = 18;
    dunst.fontSize = 16;
    alacritty.fontSize = 6;
    x.cursorSize = 14;
    polybar = {
      font0.size = "14;3";
      font1.size = "16;4";
      font2.size = "26;7";
      wirelessInterface = "wlp2s0";
      modules-right = "volume xbacklight battery wlan powermenu";
    };
    qutebrowser = {
      fonts = {
        size = "18pt";
        web.size = {
          default = 23;
          default_fixed = 21;
          minimum = 21;
        };
      };
    };
  };

  imports = [
    ../../home
  ];
}
