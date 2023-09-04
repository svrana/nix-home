{ pkgs, ... }:
{
  home.packages = [
    pkgs.bacon
    pkgs.cargo
    pkgs.cargo-edit
    pkgs.cargo-watch
    pkgs.clippy
    pkgs.rustc
  ];
}
