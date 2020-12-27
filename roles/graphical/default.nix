{ lib, config, pkgs, options, ... }:

{
  imports = [
    ./printing.nix
  ];

  services.xserver = {
    enable = true;
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
    layout = "us";
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

  environment.systemPackages = with pkgs; [
    firefox
    gnome3.adwaita-icon-theme
    pavucontrol
  ];
}
