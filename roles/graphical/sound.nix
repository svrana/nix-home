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
  };

  environment.etc."pipewire/pipewire.conf.d/switch-on-connect.conf".text = ''
    # override for pipewire-pulse.conf file
    pulse.cmd = [
      { cmd = "load-module" args = "module-always-sink" flags = [ ] }
      { cmd = "load-module" args = "module-switch-on-connect" }
    ]
    '';
}
