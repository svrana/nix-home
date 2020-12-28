{ ... }:
{
  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";
    layout = "us";
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
