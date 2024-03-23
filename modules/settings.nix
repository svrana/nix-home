{ pkgs, lib, ... }:

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
        default = 9.0;
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
      theme = {
        withHashTag = {
          base04 = mkOption {
            default = "#839496"; #839496
            type = types.str;
          };
          base05 = mkOption {
            default = "#93a1a1"; #93a1a1
            type = types.str;
          };
          base06 = mkOption {
            default = "#eee8d5"; #eee8d5
            type = types.str;
          };
          base07 = mkOption {
            default = "#fdf6e4"; #fdf6e4
            type = types.str;
          };
          base00 = mkOption {
            default = "#002b36"; #002b36
            type = types.str;
          };
          base01 = mkOption {
            default = "#073642"; #073642
            type = types.str;
          };
          base02 = mkOption {
            default = "#586e75"; #586e75
            type = types.str;
          };
          base03 = mkOption {
            default = "#657b83"; #657b83
            type = types.str;
          };
          base0A = mkOption {
            default = "#b58900"; #b58900
            type = types.str;
          };
          base09 = mkOption {
            default = "#cb4b16"; #cb4b16
            type = types.str;
          };
          base08 = mkOption {
            default = "#dc322f"; #dc322f
            type = types.str;
          };
          base0F = mkOption {
            default = "#d33682"; #d33682
            type = types.str;
          };
          base0E = mkOption {
            default = "#6c71c4"; #6c71c4
            type = types.str;
          };
          base0D = mkOption {
            default = "#268bd2"; #268bd2
            type = types.str;
          };
          base0C= mkOption {
            default = "#2aa198"; #2aa198
            type = types.str;
          };
          base0B= mkOption {
            default = "#859900"; #859900
            type = types.str;
          };
        };
        base04 = mkOption {
          default = "839496"; #839496
          type = types.str;
        };
        base05 = mkOption {
          default = "93a1a1"; #93a1a1
          type = types.str;
        };
        base06 = mkOption {
          default = "eee8d5"; #eee8d5
          type = types.str;
        };
        base07 = mkOption {
          default = "fdf6e4"; #fdf6e4
          type = types.str;
        };
        base00 = mkOption {
          default = "002b36"; #002b36
          type = types.str;
        };
        base01 = mkOption {
          default = "073642"; #073642
          type = types.str;
        };
        base02 = mkOption {
          default = "586e75"; #586e75
          type = types.str;
        };
        base03 = mkOption {
          default = "657b83"; #657b83
          type = types.str;
        };
        base0A = mkOption {
          default = "b58900"; #b58900
          type = types.str;
        };
        base09 = mkOption {
          default = "cb4b16"; #cb4b16
          type = types.str;
        };
        base08 = mkOption {
          default = "dc322f"; #dc322f
          type = types.str;
        };
        base0F = mkOption {
          default = "d33682"; #d33682
          type = types.str;
        };
        base0E = mkOption {
          default = "6c71c4"; #6c71c4
          type = types.str;
        };
        base0D = mkOption {
          default = "268bd2"; #268bd2
          type = types.str;
        };
        base0C = mkOption {
          default = "2aa198"; #2aa198
          type = types.str;
        };
        base0B = mkOption {
          default = "859900"; #859900
          type = types.str;
        };
      };
      fuzzel = {
        font = mkOption {
          default = "Hack:size=8";
          type = types.str;
        };
        width = mkOption {
          default = 50;
          type = types.int;
        };
        inner_pad = mkOption {
          default = 5;
          type = types.int;
        };
      };
      # window manager
      wm = {
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
      terminal = {
        font = mkOption {
          default = "Hack Nerd Font:size=11.50";
          type = types.str;
        };
        executable = mkOption {
          default = "${pkgs.foot}/bin/foot";
          type = types.str;
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
