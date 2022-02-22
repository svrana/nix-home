{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud23;
    hostName = "v.net";
    config = {
      adminuser = "root";
      adminpassFile = "/nextcloud-admin-passfile";
      defaultPhoneRegion = "US";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80 # web ui
    6767 # caldav
  ];
}
