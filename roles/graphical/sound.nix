{ pkgs, ... }:
{
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

    extraConfig = ''
      load-module module-switch-on-connect
    '';
    # module-esound-protocol-tcp
    # attempt to move this modules ~/esd-auth out of the ~/
    # no work
    # extraClientConf = ''
    #   auth-cookie = .config/pulse/esd-auth-cookie
    # '';
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
