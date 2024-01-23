{ pkgs, config, ... }:

{
  services.printing = {
    enable = true;
  };

  # for printer discovery
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns4 = true;
  # bonjour (dnssd) has worked well for me, i.e.,
  # lpinfo --include-schemes dnssd -v
  # lpadmin -p printername -v dnssd://foobarbaz
  # brother works just fine using the ipp driver, i.e., with ipp://brother
}
