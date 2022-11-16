{ pkgs, ... }:
let goPath = "$XDG_CACHE_HOME/go";
in
{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    package = pkgs.go_1_19;
  };

  home.packages = with pkgs; [
    gopls
    golangci-lint
    gotools
  ];

  home.sessionPath = [ "${goPath}/bin" ];
}
