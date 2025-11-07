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
      ubuntu-classic
      powerline-fonts
      font-awesome
      hack-font
      dejavu_fonts
      nerd-fonts.ubuntu-mono
      nerd-fonts.hack
    ];
  };
}
