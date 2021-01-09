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
      alacrittyFontSize = mkOption {
        default = 14;
        type = types.int;
      };
      rofiFontSize = mkOption {
        default = 18;
        type = types.int;
      };
      dunstFontSize = mkOption {
        default = 16;
        type = types.int;
      };
      cursorSize = mkOption {
        default = 14;
        type = types.int;
      };
      polybar = {
        font0Size = mkOption {
          default = "18;3";
          type = types.str;
        };
        font1Size = mkOption {
          default = "18;4";
          type = types.str;
        };
        font2Size = mkOption {
          default = "26;7"; # untested
          type = types.str;
        };
        wirelessInterface = mkOption {
          default = "wlp2s0";
          type = types.str;
        };
        wiredInterface = mkOption {
          default = "eno1";
          type = types.str;
        };
      };
    };
  };
}
