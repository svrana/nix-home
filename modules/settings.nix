{config, pkgs, lib, ...}:

with lib;

{
  options = {
    settings = {
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
      polybarFontSize = mkOption {
        default = 18;
        type = types.int;
      };
      cursorSize = mkOption {
        default = 14;
        type = types.int;
      };
      polybar = {
        font0Size = mkOption {
          default = "18;3";
          type = types.string;
        };
        font1Size = mkOption {
          default = "18;4";
          type = types.string;
        };
        font2Size = mkOption {
          default = "22;7";
          type = types.string;
        };
      };
    };
  };
}
