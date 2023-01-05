{ pkgs, config, ... }:
# Config for pi-hole like device
{

  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        port = 54;
      };
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings.dns.bind_host = "0.0.0.0";
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };

  # add to host file here so it works for entire network..
  networking.extraHosts = ''
    192.168.7.170 brother
  '';
}
