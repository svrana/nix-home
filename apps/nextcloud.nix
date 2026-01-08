{ pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "nextcloud.heimlab.link";
    # use https for generated links
    https = true;
    config = {
      adminuser = "root";
      adminpassFile = "/nextcloud-admin-passfile";
    };
    settings = {
      default_phone_region = "US";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80 # web ui
    6767 # caldav
  ];
}
