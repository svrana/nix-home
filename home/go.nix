{ pkgs, ... }:
let goPath = ".cache/go";
in
{
  programs.go = {
    enable = true;
    goPath = "${goPath}";
    package = pkgs.go_1_19;
  };

  home.packages = with pkgs; [
    gopls
    golangci-lint
    gotools
  ];

  home.sessionPath = [ "${goPath}" ];
}
