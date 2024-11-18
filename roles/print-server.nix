{ pkgs, config, ... }:
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
    publish = {
      enable = true;
      userServices = true;
    };
    openFirewall = true;
  };
}
