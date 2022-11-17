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
    wireplumber.enable = true;
    media-session.enable = false;
    config.pipewire-pulse = {
        # Extra modules can be loaded here. Setup in default.pa can be moved here
        "context.exec" = [
          {
            path = "pactl";
            args = "load-module module-switch-on-connect";
          }
        ];
      };
    };
}
