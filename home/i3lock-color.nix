{ pkgs, ... }:
let
  i3lock-color = "${pkgs.i3lock-color}/bin/i3lock-color";
  i3lockwrapper = pkgs.writeScript "i3lockwrapper" ''
    #!${pkgs.bash}/bin/bash

    i3lock_running() {
        pid=$(pidof i3lock)
        if [ -n "$pid" ]; then
            echo "i3lock already running"
            return 0
        fi
        return 1
    }

    screenblank_enable() {
        xset +dpms
        xset s on
    }

    screenblank_disable() {
        xset -dpms
        xset s off
    }

    lock() {
        # save current workspace
        current=$(i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
        # go to empty workspace in case I end up typing in a password and its not locked, so it doesn't end up in slack or something silly
        i3-msg workspace 7

        screenblank_enable
        ${pkgs.i3lock-color}/bin/i3lock-color -c 002b36 --ignore-empty-password --no-unlock-indicator --clock --nofork --datestr="%A, %B %d %G" --timesize=48 --datesize=24
        screenblank_disable

        # go to previous workspace
        i3-msg workspace "$current"
    }

    if i3lock_running ; then
      exit 0
    fi

    lock
  '';
in
{
  services.screen-locker = {
    enable = true;
    inactiveInterval = 8;
    xautolockExtraOptions = [
      "-corners '--00'"
      "-cornersize 20"
    ];
    lockCmd = "${i3lockwrapper}";
  };
}
