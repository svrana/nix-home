{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    goPath = ".cache/go";
    package = pkgs.go_1_18;
  };

  home.packages = with pkgs; [
    gopls
    golangci-lint
    gotools
  ];
}
