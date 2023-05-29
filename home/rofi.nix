{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-calc pkgs.rofi-emoji pkgs.rofi-file-browser ]; };
    theme = "solarized";
    font = "SFNS ${toString config.settings.rofi.fontSize}";
    terminal = "${pkgs.foot}/bin/foot";
    extraConfig = {
      modi = "drun,run,emoji,ssh,calc";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
    };
  };
}
