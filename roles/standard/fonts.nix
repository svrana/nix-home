{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    corefonts
    ubuntu_font_family
    powerline-fonts
    font-awesome
    hack-font
    #jetbrains-mono
    #source-code-pro
    #mononoki
    fira-code
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];
}
