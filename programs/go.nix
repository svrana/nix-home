{ pkgs, lib, ... }:

{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    packages."github.com/svrana/powerline-go" = builtins.fetchGit "https://github.com/svrana/powerline-go";
  };

  programs.bash.initExtra = ''
    PATH_append "$GOPATH/bin"
  '';
}
