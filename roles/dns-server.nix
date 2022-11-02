{ pkgs, config, ... }:
# Config for pi-hole like device
{

  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings.dns.bind_host = "0.0.0.0";
    settings.dns.bootstrap_dns = [
      "9.9.9.10"
      "149.112.112.10"
      "2620:fe::10"
      "2620:fe::fe:10"
    ];

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
