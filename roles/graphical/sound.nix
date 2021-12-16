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

  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  #
  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  #
  #   # for better sounds
  #   # media-session.config.bluez-monitor.rules = [
  #   #   {
  #   #     # Matches all cards
  #   #     matches = [{ "device.name" = "~bluez_card.*"; }];
  #   #     actions = {
  #   #       "update-props" = {
  #   #         "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
  #   #       };
  #   #     };
  #   #   }
  #   #   {
  #   #     matches = [
  #   #       # Matches all sources
  #   #       { "node.name" = "~bluez_input.*"; }
  #   #       # Matches all outputs
  #   #       { "node.name" = "~bluez_output.*"; }
  #   #     ];
  #   #     actions = {
  #   #       "node.pause-on-idle" = false;
  #   #     };
  #   #   }
  #   #   # {
  #   #   # # Allow a phone etc to use this computer as a bluetooth "speaker"
  #   #   #  matches = [ { "device.name" = "bluez_card.PHONE_MAC_HERE"; } ];
  #   #   #    actions = {
  #   #   #      "update-props" = {
  #   #   #       "bluez5.auto-connect" = [ "hfp_ag" "hsp_ag" "a2dp_source" ];
  #   #   #       "bluez5.a2dp-source-role" = "input";
  #   #   #     };
  #   #   #  };
  #   #   #}
  #   # ];
  # };

}
