{ pkgs, ... }:
{
  home.packages = with pkgs; [
    k9s
  ];

  xdg.configFile."k9s/skin.yml" = { source = ./skin.yml; };

  home.sessionVariables = {
      K9SCONFIG = "$HOME/.config/k9s";
  };
}
