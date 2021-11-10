{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    package = pkgs.go_1_17;
  };

  config.home.sessionPath = [
    "${config.home.homeDirectory}/.cache/go/bin"
  ];
}
