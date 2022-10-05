{ config, networking, ... }:
{
  services.tailscale.enable = true;

  networking.networkmanager.unmanaged = "tailscale0";

  networking.firewall = {
    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setup
    checkReversePath = "loose";
    # enable the firewall
    enable = true;
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    allowedUDPPorts = [
      config.services.tailscale.port
    ];
  };
}
