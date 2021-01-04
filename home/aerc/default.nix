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

  #home.file.".local/share/applications/aerc.desktop".source = ./aerc.desktop;
  #home.file.".local/share/applications/cmus.desktop".source = ./cmus.desktop;
}
