{ pkgs, lib, ... }:

{
  programs.dircolors = {
    enable = true;
  #  #extraConfig = builtins.readFile ./dircolors;
  };

  home.file.".dir_colors".text = builtins.readFile ./dircolors;
}
