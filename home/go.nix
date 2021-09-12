{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    package = pkgs.go_1_17;
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
