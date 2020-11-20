{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
