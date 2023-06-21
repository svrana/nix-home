{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "nextcloud.heimlab.link";
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
