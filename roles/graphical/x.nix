{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    (
      # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
      pkgs.writeTextFile {
        name = "start-sway";
        destination = "/bin/start-sway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment

          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  programs.sway.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      options = "ctrl:nocaps";
      layout = "us";
    };

    # TODO: should be configurable per host
    dpi = 96;
    displayManager.lightdm.enable = false;
    #   displayManager = {
    #     defaultSession = "sway";
    #     job.logToFile = false;
    #     lightdm = {
    #       enable = true;
    #       greeters.gtk = {
    #         enable = true;
    #         # Bad upstream defaults https://github.com/Xubuntu/lightdm-gtk-greeter/issues/85.
    #         indicators = [ "~host" "~spacer" "~session" "~a11y" "~clock" "~power" ];
    #       };
    #       # move .Xauthority out of home directory. Unfortunately appimages
    #       # don't seem be able able to get to the Xauthority file.
    #       #extraConfig = "user-authority-in-system-dir = true";
    #     };
    #   };
    #   desktopManager.session = [
    #     {
    #       name = "sway";
    #       start = "start-sway" + "\n";
    #       bgSupport = false;
    #     }
    #   ];
  };
}


