{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };
  # for printer discovery
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  # bonjour (dnssd) has worked well for me, i.e.,
  # lpinfo --include-schemes dnssd -v
  # lpadmin -p printername -v dnssd://foobarbaz
}
