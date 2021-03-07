{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";
    layout = "us";
    displayManager = {
      defaultSession = "home-manager";
      job.logToFile = false;
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
        };
        # move .Xauthority out of home directory. Unfortunately appimages
        # don't seem be able able to get to the Xauthority file.
        #extraConfig = "user-authority-in-system-dir = true";
      };
    };
    desktopManager.session = [
      {
        # mostly so we don't have to have ~/.xsession file
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
