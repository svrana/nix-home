{ ... }:
{
  services.xserver = {
    enable = true;
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
    layout = "us";
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
        };
      };
    };
    windowManager.i3.enable = true;
  };
}
