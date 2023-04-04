{ pkgs, ... }:
{
  fonts = {
    # but not enabled ..
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };

    fonts = with pkgs; [
      corefonts
      ubuntu_font_family
      powerline-fonts
      font-awesome
      hack-font
      dejavu_fonts
      (nerdfonts.override { fonts = [ "UbuntuMono" "Hack" ]; })
    ];
  };
}
