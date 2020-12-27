{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./users.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  # can be removed when we move to flakes
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "20.09";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
  ];

  services.openssh.enable = true;
  services.accounts-daemon.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
