{ config, ... }:
let
  colors = config.my.theme;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Solarized Dark Patched";
      font-family = "Hack Nerd Font";
      font-size = 11.50;
      background = colors.base00;
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
        "ctrl+j=goto_split:down" # does not work with ctrl-j used as a prefix
        "ctrl+k=goto_split:up"

        "ctrl+j>-=new_split:down"
        "ctrl+j>|=new_split:right"  # does not work
        "ctrl+j>z=toggle_split_zoom"
      ];
    };
  };
}
