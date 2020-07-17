{ pkgs, lib, ... }:

{
  #pkgs.k9s.enable = true;

  #TODO: add home-manager module to handle config
  home.file."k9s_skin" = {
    target = ".k9s/skin.yml";
    source = ./skin.yml;
  };
}
