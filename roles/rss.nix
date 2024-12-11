{ ... }:
{
  services.commafeed = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 8082 ];
}
