{ config, pkgs, home, lib, ... }:

let
  spicetify = fetchTarball https://github.com/pietdevries94/spicetify-nix/archive/master.tar.gz;
in
{
  imports = [ (import "${spicetify}/module.nix") ];

  home.packages = [ pkgs.spotify ];
  programs.spicetify = {
    enable = false;
    theme = "SolarizedDark";
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
  };
}
