{ config, ... }:
let
  colors = config.my.theme;
in
{
  programs.alacritty = {
    enable = true;
    settings =
      {
        window = {
          dimensions.columns = 140;
          dimensions.lines = 140;
          padding.x = 0;
          padding.y = 0;
          decorations = "full";
          #title = true;
          opacity = 1.0;
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        font = {
          normal = {
            family = config.my.alacritty.fontFamily;
            style = "Regular";
          };
          bold = {
            family = config.my.alacritty.fontFamily;
            style = "Bold";
          };
          italic = {
            family = config.my.alacritty.fontFamily;
            style = "Italic";
          };
          size = config.my.alacritty.fontSize;
          offset.x = 0;
          offset.y = 0;
        };
        colors = {
          primary = {
            background = "0x${colors.base00}";
            foreground = "0x${colors.base04}";
          };
          normal = {
            black = "0x${colors.base01}";
            red = "0x${colors.base08}";
            green = "0x${colors.base0B}";
            yellow = "0x${colors.base0A}";
            blue = "0x${colors.base0D}";
            magenta = "0x${colors.base0F}";
            cyan = "0x${colors.base0C}";
            white = "0x${colors.base06}";
          };
          bright = {
            black = "0x${colors.base00}";
            red = "0x${colors.base08}";
            green = "0x${colors.base0B}";
            yellow = "0x${colors.base0A}";
            blue = "0x${colors.base0D}";
            magenta = "0x${colors.base0F}";
            cyan = "0x${colors.base0C}";
            white = "0x${colors.base07}";
          };
          draw_bold_text_with_bright_colors = true;
        };
        bell.duration = 0;

        mouse = {
          hide_when_typing = true;
          bindings = [
            {
              mouse = "Middle";
              action = "PasteSelection";
            }
          ];
        };
        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        };
        cursor.style = "Block";
        live_config_reload = true;
      };
  };
}
