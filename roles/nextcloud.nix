{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "nextcloud.heimlab.link";
    # use https for generated links
    https = true;
    config = {
      adminuser = "root";
      adminpassFile = "/nextcloud-admin-passfile";
    };
    extraOptions = {
      default_phone_region = "US";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80 # web ui
    6767 # caldav
  ];
}
