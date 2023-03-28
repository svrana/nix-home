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
    # config.pipewire-pulse = {
    #   # Extra modules can be loaded here. Setup in default.pa can be moved here
    #   "context.exec" = [
    #     {
    #       path = "pactl";
    #       args = "load-module module-switch-on-connect";
    #     }
    #   ];
    # };
    #
    #   - The option definition `services.pipewire.config' in `/nix/store/l3hhfndd07zpdazl8k5z3lmq2vrp8zad-source/roles/graphical/sound.nix' no longer has any effect; please remove it.
    #   Overriding default Pipewire configuration through NixOS options never worked correctly and is no longer supported.
    #   Please create drop-in files in /etc/pipewire/pipewire.conf.d/ to make the desired setting changes instead.
  };
}
