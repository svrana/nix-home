{ pkgs, ... }:
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
    desktopManager.session = [
      {
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.config/X11/xsession &
          waitPID=$!
        '';
      }
    ];
    windowManager.i3.enable = true;
  };
}
