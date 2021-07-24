{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };
    theme = "solarized";
    font = "SFNS ${toString config.settings.rofi.fontSize}";
    borderWidth = 0;
    rowHeight = 1;
    scrollbar = false;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    padding = 16;
  };
}
