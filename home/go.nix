{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    #package = pkgsUnstable.go_1_16;
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
