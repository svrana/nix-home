{ pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    stdlib = builtins.readFile ./direnvrc;
  };
}
