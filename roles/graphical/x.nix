{ pkgs, lib, ... }:
{

  environment.systemPackages = with pkgs; [
    (
      pkgs.writeTextFile {
        name = "start-sway";
        destination = "/bin/start-sway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          #systemctl --user import-environment PATH DISPLAY WAYLAND_DISPLAY SWAYSOCK DOTFILES RCS BIN_DIR GNUPGHOME PASSWORD_STORE_DIR
          systemctl --user import-environment

          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";
    # TODO: should be configurable per host
    dpi = 96;
    layout = "us";
    displayManager = {
      defaultSession = "home-manager";
      job.logToFile = false;
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          # Bad upstream defaults https://github.com/Xubuntu/lightdm-gtk-greeter/issues/85.
          indicators = [ "~host" "~spacer" "~session" "~a11y" "~clock" "~power" ];
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
      {
        name = "hm-sway";
        start = "start-sway";
      }
    ];
    windowManager.i3.enable = true;
  };
}
