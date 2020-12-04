{ config, pkgs, lib, ... }:

let
  spicetify = fetchTarball https://github.com/pietdevries94/spicetify-nix/archive/master.tar.gz;
in
{
  imports = [ (import "${spicetify}/module.nix") ];

  programs.spicetify = {
    enable = true;
    theme = "SolarizedDark";
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
  };
}
