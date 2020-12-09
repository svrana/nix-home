# Edit this configuration file to define what should be installed on
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../arch/amd
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bocana";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
    layout = "us";
    videoDrivers = [ "amdgpu" ];
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          #theme = {
          #  package = pkgs.numix-solarized-gtk-theme;
          #  name = "NumixSolarizedDarkCyan";
          #};
          #iconTheme = {
          #  package = pkgs.paper-icon-theme;
          #  name = "Paper";
          #};
        };
      };
    };
    windowManager.i3.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };
  # for printer discovery
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  hardware.bluetooth = {
    enable = true;
    config = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    extraConfig = "load-module module-switch-on-connect";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    shell = pkgs.bash;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    gnome3.adwaita-icon-theme
    bluez
    bluez-tools
    pavucontrol
  ];

  fonts.fonts = with pkgs; [
    corefonts
    ubuntu_font_family
    powerline-fonts
    font-awesome
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.dconf.enable = true;

  # List services that you want to enable:

  # enabling for standard-notes which uses libsecret
  services.gnome3.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ]; # fixes pinentry-gnome3 from working on none-Gnome systems.
  services.blueman.enable = true;
  services.openssh.enable = true;
  services.accounts-daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  # Required because /run/user/1000 tempfs is too small for docker
  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
  '';

  security.sudo.wheelNeedsPassword = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09";
}
