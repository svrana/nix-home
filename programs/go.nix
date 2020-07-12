{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    # packages = ''
    # '';
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
