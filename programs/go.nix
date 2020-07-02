{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".go";
    # packages = ''
    # '';
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
