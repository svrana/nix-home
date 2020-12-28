{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile."rofi/config" = {
    text = ''
      rofi.theme: solarized
      rofi.font: SFNS ${toString config.settings.rofiFontSize}
      rofi.columns: 1
      rofi.bw: 0
      rofi.eh: 1
      rofi.hide-scrollbar: true
    '';
  };
}
