{config, pkgs, lib, ...}:

with lib;

{
  options = {
    settings = {
      i3 = {
        font = mkOption {
          default = "System San Francisco Display 12";
          type = types.str;
        };
      };
      alacritty = {
        fontSize = mkOption {
          default = 14;
          type = types.int;
        };
      };
      rofi = {
        fontSize = mkOption {
          default = 18;
          type = types.int;
        };
      };
      dunst = {
        fontSize = mkOption {
          default = 16;
          type = types.int;
        };
      };
      x = {
        cursorSize = mkOption {
          default = 14;
          type = types.int;
        };
      };
      polybar = {
        font0 =  {
          size = mkOption {
            default = "18;3";
            type = types.str;
          };
        };
        font1= {
          size = mkOption {
            default = "18;4";
            type = types.str;
          };
        };
        font2 = {
          size = mkOption {
            default = "26;7"; # untested
            type = types.str;
          };
        };
        wirelessInterface = mkOption {
          default = "wlp2s0";
          type = types.str;
        };
        wiredInterface = mkOption {
          default = "eno1";
          type = types.str;
        };
        modules-right = mkOption {
          default = "volume xbacklight battery wlan eth powermenu";
          type = types.str;
        };
      };
    };
  };
}
