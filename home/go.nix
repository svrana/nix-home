{ pkgs, ... }:
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
}
