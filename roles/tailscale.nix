{ config, ... }:
{
  services.tailscale.enable = true;

  # Attempt to wait until online service is finished, otherwise wait online will fail.
  # See: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.tailscaled.after = ["NetworkManager-wait-online.service"];

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
