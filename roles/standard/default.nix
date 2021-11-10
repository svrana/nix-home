{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./pkgs.nix
    ./groups.nix
    ./users.nix
    ./udev.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  # Limit the systemd journal to 100 MB of disk or the last 7 days of logs whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.accounts-daemon.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;

  # Will run a caching dns server on :53 which conflicts with adguardhome
  # services.resolved = {
  #     enable = true;
  #     dnssec = "false";
  #   };

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [
      config.services.tailscale.port
      21027 # syncthing
    ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [
      22
      22000 # syncthing
    ];
  };
}
