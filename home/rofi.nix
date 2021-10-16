{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ]; };
    theme = "solarized";
    font = "SFNS ${toString config.settings.rofi.fontSize}";
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
}
