{ pkgs, config, ... }:

{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };
  # for printer discovery
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  #services.avahi.nssmdns = true;
  # bonjour (dnssd) has worked well for me, i.e.,
  # lpinfo --include-schemes dnssd -v
  # lpadmin -p printername -v dnssd://foobarbaz
  services.avahi.nssmdns = false; # Use my settings from below
  # settings from avahi-daemon.nix where mdns is replaced with mdns4
  system.nssModules = with pkgs.lib; optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns) (mkMerge [
    (mkOrder 900 [ "mdns4_minimal [NOTFOUND=return]" ]) # must be before resolve
    (mkOrder 1501 [ "mdns4" ]) # 1501 to ensure it's after dns
  ]);
}
