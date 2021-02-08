{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./pkgs.nix
    ./users.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "20.09";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.openssh.enable = true;
  services.accounts-daemon.enable = true;
  security.sudo.wheelNeedsPassword = false;


  services.tailscale.enable = false;
  # networking.firewall = {
  #   # enable the firewall
  #   enable = true;

  #   # always allow traffic from your Tailscale network
  #   trustedInterfaces = [ "tailscale0" ];

  #   # allow the Tailscale UDP port through the firewall
  #   allowedUDPPorts = [ config.services.tailscale.port ];

  #   # allow you to SSH in over the public internet
  #   allowedTCPPorts = [ 22 ];
  # };
}
