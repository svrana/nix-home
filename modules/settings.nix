{config, pkgs, lib, ...}:

with lib;

{
  options = {
    settings = {
      alacrittyfontSize = mkOption {
        default = 19;
        type = types.int;
      };
      rofiFontSize = mkOption {
        default = 18;
        type = types.int;
      };
      dunstfontSize = mkOption {
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
