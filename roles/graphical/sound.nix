{ pkgs, ... }:
{
  # So things that rely on pulseaudio command still work.
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    pamixer
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pipewire-pulse = {
    };
    #jack.enable = true;
    wireplumber.enable = true;
    #media-session.enable = true;
    media-session.enable = false;
  };

  # hardware.pulseaudio.extraConfig = "
  #   load-module module-switch-on-connect
  # ";
}
