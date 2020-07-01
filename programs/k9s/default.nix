{ pkgs, lib, ... }:

{
  #programs.k9s.enable = true;

  home.file."k9s_skin" = {
    target = ".k9s/skin.yml";
    source = ./skin.yml;
  };
}
