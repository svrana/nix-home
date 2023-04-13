{ config, pkgs, lib, ... }:

with lib;

let
  # from home-manager i3-swap/lib/options.nix
  fontOptions = types.submodule {
    options = {
      names = mkOption {
        type = types.listOf types.str;
        default = [ "monospace" ];
        defaultText = literalExample ''[ "monospace" ]'';
        description = ''
          List of font names list used for window titles. Only FreeType fonts are supported.
          The order here is important (e.g. icons font should go before the one used for text).
        '';
        example = literalExample ''[ "FontAwesome" "Terminus" ]'';
      };

      style = mkOption {
        type = types.str;
        default = "";
        description = ''
          The font style to use for window titles.
        '';
        example = "Bold Semi-Condensed";
      };

      size = mkOption {
        type = types.float;
        default = 8.0;
        description = ''
          The font size to use for window titles.
        '';
        example = 11.5;
      };
    };
  };
in
{
  options = {
    settings = {
      i3 = {
        fonts = mkOption {
          type = with types; either (listOf str) fontOptions;
          default = {
            names = [ "SFNS Display" ];
            style = "Regular";
            size = 12.0;
          };
          example = literalExample ''
            {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            style = "Bold Semi-Condensed";
            size = 11.0;
            }
          '';
          description = "Font configuration for window titles, nagbar...";
        };
      };
      alacritty = {
        fontFamily = mkOption {
          default = "Hack Nerd Font";
          type = types.str;
        };
        fontSize = mkOption {
          default = 11.50;
          type = types.float;
        };
      };
      rofi = {
        fontSize = mkOption {
          default = 12;
          type = types.int;
        };
        iconSize = mkOption {
          default = "1.8ch";
          type = types.str;
        };
      };
      dunst = {
        fontSize = mkOption {
          default = 12;
          type = types.int;
        };
      };
      x = {
        cursorSize = mkOption {
          default = 14;
          type = types.int;
        };
        dpi = mkOption {
          default = 96;
          type = types.int;
        };
      };
      waybar = {
        interfaces = mkOption {
          default = "eno1";
          type = types.str;
        };
      };
      polybar = {
        font0 = {
          size = mkOption {
            default = "10;2";
            type = types.str;
          };
        };
        font1 = {
          size = mkOption {
            default = "12;0";
            type = types.str;
          };
        };
        font2 = {
          size = mkOption {
            default = "22;4"; # untested
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
      qutebrowser = {
        fonts = {
          size = mkOption {
            default = "13pt";
            type = types.str;
          };
          web = {
            size = {
              default = mkOption {
                default = 19;
                type = types.int;
              };
              default_fixed = mkOption {
                default = 16;
                type = types.int;
              };
              minimum = mkOption {
                default = 14;
                type = types.int;
              };
            };
          };
        };
      };
    };
  };
}
