{ lib, config, pkgs, options, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  users.users.shaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    shell = pkgs.bash;
    initialPassword = "shaw";
  };

  # can be removed when we move to flakes
  nixpkgs.config.allowUnfree = true;

  nix = {
    trustedUsers = [ "@wheel" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "20.09";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    corefonts
    ubuntu_font_family
    powerline-fonts
    font-awesome
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  environment.systemPackages = with pkgs; [
    wget
    vim
  ];
}
