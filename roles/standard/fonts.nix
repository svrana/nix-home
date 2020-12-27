{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    corefonts
    ubuntu_font_family
    powerline-fonts
    font-awesome
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];
}
