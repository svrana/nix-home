{ config, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };

  # Attempt to wait until online service is finished, otherwise wait online will fail.
  # See: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.tailscaled.after = ["NetworkManager-wait-online.service"];

  networking.firewall = {
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
  };
}
