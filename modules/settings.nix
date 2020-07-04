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
    };
  };
}
