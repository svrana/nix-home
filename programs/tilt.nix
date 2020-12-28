{ pkgsUnstable, ... }:
{
  home.packages = with pkgsUnstable; [
    tilt
  ];

  programs.bash.sessionVariables = {
      TILT_DEV_DIR = "$XDG_CONFIG_HOME/tilt";
  };
}
