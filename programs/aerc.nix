{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    aerc
  ];

  home.activation.copyAercAccounts =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -D -m600 ${
        ../personal/aerc/accounts.conf
      } $XDG_CONFIG_HOME/aerc/accounts.conf
    '';

  xdg.configFile."aerc" = {
    source = ../config/aerc;
    recursive = true;
  };
}
