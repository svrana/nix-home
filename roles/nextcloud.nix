{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud25;
    hostName = "v.net";
    config = {
      adminuser = "root";
      adminpassFile = "/nextcloud-admin-passfile";
      defaultPhoneRegion = "US";
    };
    enableBrokenCiphersForSSE = false;
  };

  networking.firewall.allowedTCPPorts = [
    80 # web ui
    6767 # caldav
  ];
}
