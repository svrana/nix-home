{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./docker.nix
    ./home.nix
    ./printing.nix
    ./sound.nix
  ];

  services.xserver = {
    enable = true;
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
    layout = "us";
    # move out video driving setting to module
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    # deviceSection = ''
    #   might need to set intel driver for this to work? though modesetting recommended
    #   Option "DRI" "2"
    #   Option "TearFree" "true"
    # '';
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

  # hardware.bluetooth = {
  #   enable = true;
  #   config = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  # };
  # services.blueman.enable = true;

  # sound = {
  #   enable = true;
  #   mediaKeys.enable = true;
  # };

  # hardware.pulseaudio = {
  #   enable = true;
  #   extraModules = [ pkgs.pulseaudio-modules-bt ];
  #   # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
  #   # Only the full build has Bluetooth support, so it must be selected here.
  #   package = pkgs.pulseaudioFull;
  #   extraConfig = "load-module module-switch-on-connect";
  # };

  environment.systemPackages = with pkgs; [
    firefox
    gnome3.adwaita-icon-theme
  ];

  programs.dconf.enable = true;

  # enabling for standard-notes which uses libsecret
  services.gnome3.gnome-keyring.enable = true;
  services.dbus.packages = [ pkgs.gcr ]; # fixes pinentry-gnome3 from working on none-Gnome systems.

  # virtualisation.docker.enable = true;
  # virtualisation.docker.enableOnBoot = true;
  # # Required because /run/user/1000 tempfs is too small for docker
  # services.logind.extraConfig = ''
  #   RuntimeDirectorySize=8G
  # '';
}
