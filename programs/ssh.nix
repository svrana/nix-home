{ pkgs, lib, ... }:

{
  home.file.".ssh" = {
    source = ../personal/ssh;
    recursive = true;
  };
}
