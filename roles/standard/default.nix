{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./pkgs.nix
    ./groups.nix
    ./users.nix
    ./udev.nix
    ../tailscale.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  # defining an xsession will set this for you, but there's not a wayland version yet, so we do this ourselves.
  boot.kernel.sysctl."fs.inotify.max_user_instances" = 524288;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  # Limit the systemd journal to 100 MB of disk or the last 7 days of logs whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
    earlySetup = true;
  };

  services.accounts-daemon.enable = true;
  security.sudo.wheelNeedsPassword = false;
  # so swaylock can unlock..
  security.pam.services.swaylock = { };

  # Will run a caching dns server on :53 which conflicts with adguardhome
  # services.resolved = {
  #     enable = true;
  #     dnssec = "false";
  #   };

  # Disable wait online as it's causing trouble at rebuild
  # See: https://github.com/NixOS/nixpkgs/issues/180175
  #systemd.services.NetworkManager-wait-online.enable = false;

  networking.firewall = {
    # enable the firewall
    enable = true;

    allowedUDPPorts = [
      21027 # syncthing
    ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [
      22
      22000 # syncthing
    ];
  };

  services.fstrim.enable = true;
}
