{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings =
      {
        window = {
          dimensions.columns = 140;
          dimensions.lines = 140;
          padding.x = 2;
          padding.y = 2;
          decorations = "full";
          #title = true;
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        draw_bold_text_with_bright_colors = true;
        font = {
          normal = {
            family = "UbuntuMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "UbuntuMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "UbuntuMono Nerd Font Mono";
            style = "Italic";
          };
          size = config.settings.alacritty.fontSize;
          offset.x = 0;
          offset.y = 0;
          gliph_offset.x = 0;
          gliph_offset.y = 0;
        };
        colors = {
          primary = {
            background = "0x002b36";
            foreground = "0x839496";
          };
          normal = {
            black = "0x073642";
            red = "0xdc322f";
            green = "0x859900";
            yellow = "0xb58900";
            blue = "0x268bd2";
            magenta = "0xd33682";
            cyan = "0x2aa198";
            white = "0xeee8d5";
          };
          bright = {
            black = "0x002b36";
            red = "0xcb4b16";
            green = "0x586e75";
            yellow = "0x657b83";
            blue = "0x839496";
            magenta = "0x6c71c4";
            cyan = "0x93a1a1";
            white = "0xfdf6e3";
          };
        };
        bell.duration = 0;
        background_opacity = 1.0;

        mouse_bindings = [
          {
            mouse = "Middle";
            action =  "PasteSelection";
          }
        ];
        mouse = {
          double_click.threshold = 300;
          triple_click.threshold = 300;
          hide_when_typing = true;
        };
        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
          save_to_clipbard = true;
        };
        cursor.style = "Block";
        live_config_reload = true;
    };
  };
}
