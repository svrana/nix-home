{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = builtins.readFile ./config/zathura-solarized-dark.rc;
  };
}
