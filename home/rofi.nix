{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ]; };
    theme = "solarized";
    font = "SFNS ${toString config.settings.rofi.fontSize}";
    borderWidth = 0;
    rowHeight = 1;
    width = 25;
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
}
