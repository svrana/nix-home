{ pkgs, lib, config, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    package = pkgs.go_1_17;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cache/go/bin"
  ];
}
