{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-calc pkgs.rofi-emoji pkgs.rofi-file-browser ]; };
    theme = "solarized";
    font = "SFNS ${toString config.settings.rofi.fontSize}";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      dpi = 0;
    };
  };
}
