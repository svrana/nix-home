{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      options = "ctrl:nocaps";
      layout = "us";
    };

    # TODO: should be configurable per host
    dpi = 96;
    displayManager.lightdm.enable = false;
  };
}


