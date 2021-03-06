{ pkgs, lib, ... }:
{

  # home.packages = with pkgsUnstable; [
  #   aerc
  # ];

  home.activation.copyAercAccounts =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -D -m600 ${
        ../../personal/aerc/accounts.conf
      } $XDG_CONFIG_HOME/aerc/accounts.conf
    '';

  xdg.configFile."aerc/aerc.conf".source = ../config/aerc/aerc.conf;
  xdg.configFile."aerc/binds.conf".source = ../config/aerc/binds.conf;
}
