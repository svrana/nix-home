{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tilt
  ];

  programs.sessionVariables = {
      TILT_DEV_DIR = "$HOME/.config/tilt";
  };
}
