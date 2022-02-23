{ pkgs, config, ... }:
# Config for pi-hole like device
{

  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  services.adguardhome = {
    enable = true;
    openFirewall = true;
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
