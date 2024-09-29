{ pkgs, ... }:
{
  home.packages = [ pkgs.tilt ];

  home.sessionVariables = {
    TILT_DEV_DIR = "$HOME/.config/tilt";
  };
}
