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

    packages = with pkgs; [
      corefonts
      ubuntu_font_family
      powerline-fonts
      font-awesome
      hack-font
      dejavu_fonts
      nerd-fonts.ubuntu-mono
      nerd-fonts.hack
    ];
  };
}
