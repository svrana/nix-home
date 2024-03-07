{ config, pkgs, lib, ... }:
let
  waybar = config.settings.waybar;
  rofi-pass = "gopass ls --flat | fuzzel --dmenu -p site | xargs --no-run-if-empty gopass show -o | wl-copy && notify-send 'Copied to clipboard' && sleep 15 && wl-copy --clear";
  ranger = "${pkgs.ranger}/bin/ranger";
  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
  terminal = "${pkgs.foot}/bin/foot";
  email_client = "${terminal} --title email --app-id email -e aerc";
  tmux-attach-or-new = pkgs.writeScript "tmux-attach" ''
    #!/usr/bin/env bash

    tproject() {
      tmuxinator start project -n "$1" workspace="$2"
    }
    tmux_from_scratch() {
      tproject dots $DOTFILES
      tproject nixpkgs $PROJECTS/nixpkgs
      tproject vranix $PROJECTS/vranix.com
      tproject b6 $PROJECTS/b6/bommie
      tproject b6-infra $PROJECTS/b6/bommie

      sleep .2
      tmux attach -t b6
    }

    tmux attach 2>&1 1>/dev/null  || tmux_from_scratch
  '';
  # see swaylock-effects repo
  swaylock-cmd = lib.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--daemonize"
    "--ignore-empty-password"
    "--color  073642"
    "--ring-color 2aa198"
    "--inside-color 002b36"
    "--clock"
    "--indicator"
    "--line-uses-inside"
    "--indicator-radius 100"
    "--indicator-thickness 7"
    "--fade-in 0.5"
    "--text-color 586e75"
  ];
  base03 = "#002b36";
  base02 = "#073642";
  base01 = "#586e75";
  base00 = "#657b83";
  base0 = "#839496";
  base1 = "#93a1a1";
  base2 = "#eee8d5";
  base3 = "#fdf6e3";
  yellow = "#b58900";
  orange = "#cb4b16";
  red = "#dc322f";
  magenta = "#d33682";
  violet = "#6c71c4";
  blue = "#268bd2";
  cyan = "#2aa198";
  green = "#859900";
  bartext = "#2C3530";
  widgetbg = "${base01}";
in
{
  # TODO:
  #   ranger image preview
  #      anyway to do this in wayland?
  #
  #   # instead of xpropr for app_id
  #   swaymsg -t get_tree
  #
  wayland = {
    windowManager = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        systemd.enable = true;
        config = {
          modifier = "Mod4";
          floating = {
            modifier = "Mod4";
            border = 2;
          };
          gaps = {
            inner = 20;
            smartGaps = true;
          };
          seat."*" = {
            hide_cursor = "when-typing enable";
          };
          bars = [ ];
          window = { hideEdgeBorders = "smart"; };
          focus = {
            followMouse = false;
            #newWindow = "focus";
            newWindow = "urgent";
          };
          fonts = config.settings.wm.fonts;
          colors = {
            focused = {
              border = "#4c7899";
              background = "${base01}";
              text = "#ffffff";
              indicator = "${blue}";
              childBorder = "${cyan}";
            };
            focusedInactive = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
              indicator = "#484e50";
              childBorder = "#5f676a";
            };
            unfocused = {
              border = "#333333";
              background = "${base02}";
              text = "#888888";
              indicator = "#292d2e";
              childBorder = "#222222";
            };
            urgent = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
              indicator = "#900000";
              childBorder = "#900000";
            };
            placeholder = {
              border = "#000000";
              background = "#0c0c0c";
              text = "#ffffff";
              indicator = "#000000";
              childBorder = "#0c0c0c";
            };
            background = "#ffffff";
          };
          keybindings =
            let
              mod = "Mod4";
            in
            {
              "${mod}+minus" = ''[app_id="scratch-term"] scratchpad show'';
              "${mod}+Return" = "exec --no-startup-id ${terminal}";
              "${mod}+Shift+q" = "kill";
              "${mod}+0" = ''[class="Standard Notes"] scratchpad show'';
              "${mod}+1" = "workspace 1";
              "${mod}+2" = "workspace 2";
              "${mod}+3" = "workspace 3";
              "${mod}+4" = "workspace 4";
              "${mod}+5" = "workspace 5";
              "${mod}+6" = "workspace 6";
              "${mod}+slash" = "workspace 6";
              "${mod}+7" = "workspace 7";
              "${mod}+9" = ''[app_id="Slack"] scratchpad show'';
              "${mod}+a" = "focus parent";
              "${mod}+d" = ''exec --no-startup-id "${fuzzel}"'';
              "${mod}+e" = "layout toggle split";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+h" = "focus left";
              "${mod}+i" = "exec --no-startup-id ${fuzzel} -d < $XDG_CONFIG_HOME/qutebrowser/quickmarks | awk '{print $2}' | xargs -r qutebrowser";
              "${mod}+j" = "focus down";
              "${mod}+k" = "focus up";
              "${mod}+l" = "focus right";
              "${mod}+m" = ''[app_id="tmux"] focus'';
              "${mod}+n" = ''[app_id="email"] focus'';
              "${mod}+p" = ''exec --no-startup-id "${rofi-pass}"'';
              "${mod}+q" = "kill";
              "${mod}+r" = "mode resize";
              "${mod}+u" = ''exec --no-startup-id "${terminal} -e ${ranger}"'';
              "${mod}+w" = ''exec --no-startup-id ${pkgs.clipman}/bin/clipman pick -t CUSTOM --tool-args="fuzzel -d"'';
              "${mod}+Shift+y" = ''exec --no-startup-id "${email_client}"'';
              "${mod}+Shift+c" = "exec swaymsg reload && notify-send 'sway config reloaded'";
              "${mod}+Shift+e" = ''mode "exit: l)ogout r)eboot su)spend h)ibernate s)hutdown"'';
              "${mod}+Shift+h" = "move left";
              "${mod}+Shift+n" = "exec --no-startup-id $BIN_DIR/cxnmgr";
              "${mod}+Shift+s" = ''exec --no-startup-id grim -g "$(slurp)" - | wl-copy'';
              "${mod}+Shift+w" = "exec --no-startup-id $BIN_DIR/screenshot";
              "${mod}+Shift+j" = "move down";
              "${mod}+Shift+k" = "move up";
              "${mod}+Shift+l" = "move right";
              "${mod}+Shift+space" = "floating toggle";
              "${mod}+space" = "focus mode_toggle";
              "${mod}+Shift+t" = "exec --no-startup-id ${terminal} --app-id tmux --title tmux -e ${tmux-attach-or-new}";
              "${mod}+Shift+1" = "move container to workspace 1";
              "${mod}+Shift+2" = "move container to workspace 2";
              "${mod}+Shift+3" = "move container to workspace 3";
              "${mod}+Shift+4" = "move container to workspace 4";
              "${mod}+Shift+5" = "move container to workspace 5";
              "${mod}+Shift+6" = "move container to workspace 6";
              "${mod}+Shift+7" = "move container to workspace 7";
              "${mod}+comma" = ''[ app_id="qutebrowser" ] focus'';
              "${mod}+period" = "workspace 4"; #"exec ${spotify-focus}";  ...spotify does not have its app_id set when run as a wayland app
              "Mod1+Control+l" = "exec ${swaylock-cmd}";
              "Mod1+Control+v" = "split horizontal";
              "Mod1+Control+h" = "split vertical";
              "Mod1+Control+m" = "exec --no-startup-id volumectl mute";
              "XF86AudioRaiseVolume" = "exec --no-startup-id volumectl raise";
              "XF86AudioLowerVolume" = "exec --no-startup-id volumectl lower";
              "XF86AudioMute" = "exec --no-startup-id volumectl %";
              "XF86AudioPlay" = "exec --no-startup-id playerctl play";
              "XF86AudioPause" = "exec --no-startup-id playerctl pause";
              "XF86AudioNext" = "exec --no-startup-id playerctl next";
              "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
              "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl -inc 20";
              "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl -dec 20";
            };
          modes = {
            resize = {
              "h" = "resize shrink width 10 px or 10 ppt";
              "j" = "resize grow height 10 px or 10 ppt";
              "k" = "resize shrink height 10 px or 10 ppt";
              "l" = "resize grow width 10 px or 10 ppt";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
            "exit: l)ogout r)eboot su)spend h)ibernate s)hutdown" = {
              "l" = "exec swaymsg exit";
              "r" = "exec sudo systemctl reboot";
              "s" = "exec sudo systemctl poweroff";
              "u" = "exec sudo systemctl suspend; mode default";
              "h" = "exec sudo systemctl hibernate; mode default";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };
          startup = [
            { command = ''${pkgs.swaybg}/bin/swaybg -c "${base03}"''; }
            { command = ''${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist''; }
            { command = ''${pkgs.wl-clipboard}/bin/wl-paste -p -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist''; }
            { command = ''standardnotes''; }
            { command = "${pkgs.slack}/bin/slack"; }
          ];
        };
        extraSessionCommands = ''
        '';
        extraConfig = ''
          set $ws1 1
          set $ws2 2
          set $ws3 3
          set $ws4 4
          set $ws5 5
          set $ws6 6

          default_border pixel 2

          for_window [class="Standard Notes"] move scratchpad, move position 1000 200, resize set 1800 1900
          for_window [class="Slack"] move scratchpad, move position 1000 200, resize set 1800 1900
          for_window [app_id="scratch-term"] move scratchpad, move position 1000 200, resize set 1800 1900

          assign [app_id="qutebrowser"] $ws3

          seat * hide_cursor 3000

          # Make all the pinentry stuff work
          # https://git.sr.ht/~sumner/home-manager-config/tree/master/item/modules/window-manager/wayland.nix#L64
          #exec dbus-update-activation-environment WAYLAND_DISPLAY

          exec ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway

          # Import the WAYLAND_DISPLAY env var from sway into the systemd user session.
          exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK
        '';
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "idle_inhibitor" "pulseaudio" "network" "clock" ];
        height = 32;

        "clock" = {
          "format" = "  {:%H:%M   %e %b}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "today-format" = "<b>{}</b>";
          #"on-click"= "gnome-calendar"
        };
        # "clock" = {
        #   "timezone" = "America/Los_Angeles";
        #   "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        #   "format-alt" = "{:%Y-%m-%d}";
        # };
        "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󰇰";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
          };
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "battery" = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "network" = {
          "interface" = "${waybar.interfaces}";
          "format-ethernet" = "  {ifname}";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "tooltip-format-wifi" = "Signal Strength: {signalStrength}%";
          "format-wifi" = "  {essid}";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "⚠";
          "format-alt" = "{ifname}: { ipaddr }/{cidr}";
        };
        "pulseaudio" = {
          "format" = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon} ";
          "format-bluetooth-muted" = "  {icon} ";
          "format-muted" = "  {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
      }
    ];
    style = ''
      * {
        font-family: 'Roboto Mono for Powerline', 'UbuntuMono Nerd Font', 'SFNS Display', Helvetica, Arial, sans-serif;
        border: none;
        border-radius: 2px;
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background: ${base02};
        border-bottom: 3px solid ${base03};
        transition-property: background;
        transition-duration: .5s;
      }
      #workspaces button {
        color: #A9B5AF;
        padding: 0px 14px 0px 10px;
        font-size: 16px;
        font-weight: bold;
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0px -3px transparent;
      }
      #workspaces button.focused {
        color: ${bartext};
        background-color: ${widgetbg};
        box-shadow: inset 0px -3px ${cyan};
      }
      #workspaces button:hover {
        color: ${bartext};
        background: #2aa198;
        box-shadow: inset 0px -3px ${base02};
      }
      #mode {
        background-color: ${base01};
        border-bottom: 3px solid ${yellow};
      }
      #workspaces button.urgent {
        background-color: ${cyan};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #idle_inhibitor,
      #tray,
      #mode,
      #custom,
      #mpd {
        /* tweak padding / margin here to get bottom of window alignment correct */
        padding: 0px 6px 0px 6px;
        margin: 6px 6px 9px 6px;
        font-weight: bold;
        border-radius: 4px;
      }

      #idle_inhibitor {
        color: #A9B5AF;
        font-weight: normal;
      }

      #clock {
        background: ${widgetbg};
        color: ${bartext};
      }

      #pulseaudio {
        background: ${widgetbg};
        color: ${bartext};
      }

      #network {
        background: ${widgetbg};
        color: ${bartext};
      }

      #window {
        font-size: 14px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0px;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0px;
      }
    '';
  };

  systemd.user.services.sway = {
    Unit = {
      Description = "Sway - Wayland window manager";
      Documentation = [ "man:sway(5)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.sway}/bin/sway";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # sway session added by hm
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle Manager for Wayland";
      PartOf = [ "sway-session.target" ];
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
      Documentation = [ "man:swayidle(1)" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      ExecStart = ''${pkgs.swayidle}/bin/swayidle -w -d \
        timeout 600 '${swaylock-cmd}' \
        before-sleep '${swaylock-cmd}' \
        timeout 700 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
          resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
      '';
    };
  };

  systemd.user.services.i3-ratiosplit = {
    Unit = {
      Description = "i3-ratiosplit";
      PartOf = [ "sway-session.target" ];
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.i3-ratiosplit}/bin/i3-ratiosplit'";
      RestartSec = 2;
      Restart = "on-failure";
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description =
        "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki";
      PartOf = [ "sway-session.target" ];
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };
  };

  systemd.user.services.scratch = {
    Unit = {
      Description = "Scratch terminal that is stashed by Sway";
      PartOf = [ "sway-session.target" ];
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.bash}/bin/bash -lc '${terminal} --app-id scratch-term --title scratch'";
      Restart = "always";
    };
  };

  systemd.user.services.avizo = {
    Unit = {
      Description = "avizo volume ctrl daemon";
      PartOf = [ "sway-session.target" ];
      Requires = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.avizo}/bin/avizo-service";
      Restart = "on-failure";
    };
  };
}
