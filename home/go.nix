{ pkgs, ... }:
let goPath = "$XDG_CACHE_HOME/go";
in
{
  programs.go = {
    enable = true;
    env.GOPATH = ".cache/go";
  };

  home.packages = with pkgs; [
    gopls
    golangci-lint
    gotools
  ];

  home.sessionPath = [ "${goPath}/bin" ];
}
