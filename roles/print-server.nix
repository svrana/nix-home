{ ... }:
# Config for a shared printer.
{
  services.printing = {
    enable = true;
    browsing = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    defaultShared = true;
  };

  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  services.avahi = {
    enable = true;
    # Important to resolve .local domains of printers, otherwise you get an error
    # like  "Impossible to connect to XXX.local: Name or service not known"
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
    openFirewall = true;
  };
}
