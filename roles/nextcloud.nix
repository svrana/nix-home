{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "nextcloud.heimlab.link";
    # use https for generated links
    https = true;
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
