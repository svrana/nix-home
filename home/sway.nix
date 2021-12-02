{ config, pkgs, lib, ... }:
let
  i3 = config.settings.i3;
  waybar = config.settings.waybar;
  rofi = "${pkgs.rofi}/bin/rofi";
  rofi-pass = "${pkgs.rofi-pass}/bin/rofi-pass";
  rofi-icon-size = config.settings.rofi.iconSize;
  maim = "${pkgs.maim}/bin/maim";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  ranger = "${pkgs.ranger}/bin/ranger";
  rofi-calc-cmd = ''rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n '{result}' | wl-copy"'';
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  email_client = "${alacritty} --class email -e neomutt";
  scratch-term = pkgs.writeScript "scratch-term" ''
    #!${pkgs.bash}/bin/bash
    while :
    do
      ${alacritty} --class scratch-term,scratch-term
      sleep .5
    done
  '';
  swaylockCmd = lib.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--daemonize"
    "--ignore-empty-password"
    "--color 073642"
    "--ring-color 2aa198"
    "--inside-color 002b36"
    "--clock"
    "--indicator"
    "--line-uses-inside"
    "--indicator-radius 100"
    "--indicator-thickness 7"
    "--effect-blur 7x5"
    "--effect-vignette 0.7:0.7"
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
in
{
  home.sessionVariables = {
    GTK_THEME = "Arc-Dark";
    MOZ_ENABLE_WAYLAND = "1";
  };
  programs.mpv.config = {
    gpu-context = "wayland";
  };
  # TODO:
  #   scratch-term spawns 3 windows after exit
  #   ranger image preview
  #      anyway to do this in wayland?
  #
  #   # try instead of xprop for classnames.. no idea
  #   swaymsg -t get_tree
  #
  wayland = {
    windowManager = {
      sway = {
        package = null;
        enable = true;
        wrapperFeatures.gtk = true;
        systemdIntegration = true;
        config = {
          modifier = "Mod4";
          floating = {
            modifier = "Mod4";
            border = 2;
          };
          gaps = {
            inner = 25;
            smartGaps = true;
          };
          seat."*" = {
            hide_cursor = "when-typing enable";
          };
          bars = [ ];
          window = { hideEdgeBorders = "smart"; };
          focus = {
            followMouse = false;
            newWindow = "focus";
          };
          fonts = config.settings.i3.fonts;
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
              "${mod}+Return" = "exec --no-startup-id ${alacritty}";
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
              "${mod}+9" = ''[class="Slack"] scratchpad show'';
              "${mod}+a" = "focus parent";
              "${mod}+c" = ''exec --no-startup-id ${rofi-calc-cmd}'';
              "${mod}+d" = ''exec --no-startup-id "${rofi} -show drun -modi drun,run -show-icons -theme-str 'element-icon { size: ${rofi-icon-size};} window {width: 25%; border-color: ${cyan};}'"'';
              "${mod}+e" = "layout toggle split";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+h" = "focus left";
              "${mod}+i" = "layout toggle stacking tabbed normal";
              "${mod}+j" = "focus down";
              "${mod}+k" = "focus up";
              "${mod}+l" = "focus right";
              "${mod}+m" = ''[app_id="tmux"] focus'';
              "${mod}+n" = ''[app_id="email"] focus'';
              "${mod}+p" = ''exec --no-startup-id "${rofi-pass}"'';
              "${mod}+q" = "kill";
              "${mod}+r" = "mode resize";
              "${mod}+s" = "layout stacking";
              "${mod}+t" = "layout tabbed";
              "${mod}+u" = ''exec --no-startup-id "alacritty -e ${ranger}"'';
              "${mod}+w" = ''exec --no-startup-id ${pkgs.clipman}/bin/clipman pick -t rofi'';
              "${mod}+x" = "layout toggle splitv splith";
              "${mod}+Shift+y" = ''exec --no-startup-id "${email_client}"'';
              "${mod}+Shift+c" = "reload";
              "${mod}+Shift+e" = ''mode "exit: l)ogout r)eboot su)spend h)ibernate"'';
              "${mod}+Shift+f" = ''exec --no-startup-id "fd | ${rofi} -show find -mode find -dmenu | xargs -r xdg-open"'';
              "${mod}+Shift+h" = "move left";
              "${mod}+Shift+n" = "exec --no-startup-id $BIN_DIR/cxnmgr";
              "${mod}+Shift+r" = "restart";
              "${mod}+Shift+s" = ''exec --no-startup-id grim -g "$(slurp)" - | wl-copy'';
              "${mod}+Shift+j" = "move down";
              "${mod}+Shift+k" = "move up";
              "${mod}+Shift+l" = "move right";
              "${mod}+Shift+space" = "floating toggle";
              "${mod}+space" = "focus mode_toggle";
              #"${mod}+Shift+t" = "exec --no-startup-id ${alacritty} --class tmux";
              "${mod}+Shift+t" = "exec --no-startup-id ${alacritty} --class tmux -e ${pkgs.tmuxinator}/bin/tmuxinator work";
              "${mod}+Shift+1" = "move container to workspace 1";
              "${mod}+Shift+2" = "move container to workspace 2";
              "${mod}+Shift+3" = "move container to workspace 3";
              "${mod}+Shift+4" = "move container to workspace 4";
              "${mod}+Shift+5" = "move container to workspace 5";
              "${mod}+Shift+6" = "move container to workspace 6";
              "${mod}+Shift+7" = "move container to workspace 7";
              "${mod}+Tab" = ''exec - -no-startup-id "${rofi} -show window -eh 2 -padding 16 -show-icons -theme-str 'element-icon { size: ${rofi-icon-size};} window {width: 25%; border-color: ${cyan};}'" '';
              "${mod}+comma" = ''[ app_id="qutebrowser" ] focus'';
              "${mod}+period" = ''[instance="spotify"] focus'';
              "Mod1+Control+l" = "exec ${swaylockCmd}";
              "Mod1+Control+v" = "split horizontal";
              "Mod1+Control+h" = "split vertical";
              "Mod1+Control+u" = "exec --no-startup-id $BIN_DIR/vol.sh --up";
              "Mod1+Control+d" = "exec --no-startup-id $BIN_DIR/vol.sh --down";
              #"Mod1+Control+m" = "exec --no-startup-id $BIN_DIR/vol.sh --togmute";
              "Mod1+Control+m" = "exec --no-startup-id volumectl mute";
              # "XF86AudioRaiseVolume" = "exec --no-startup-id $BIN_DIR/vol.sh --up";
              # "XF86AudioLowerVolume" = "exec --no-startup-id $BIN_DIR/vol.sh --down";
              # "XF86AudioMute" = "exec --no-startup-id $BIN_DIR/vol.sh --togmute";
              "XF86AudioRaiseVolume" = "exec --no-startup-id volumectl raise";
              "XF86AudioLowerVolume" = "exec --no-startup-id volumectl lower";
              "XF86AudioMute" = "exec --no-startup-id volumectl mute";
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
            "exit: l)ogout r)eboot su)spend h)ibernate" = {
              "l" = "exec i3-msg exit";
              "r" = "exec sudo systemctl reboot";
              "s" = "exec sudo systemctl poweroff";
              "u" = "exec sudo systemctl suspend";
              "h" = "exec sudo systemctl hibernate; mode default";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };
          startup = [
            { command = ''${pkgs.swaybg}/bin/swaybg -c "${base03}"''; }
            { command = ''${pkgs.avizo}/bin/avizo-service''; }
            { command = ''${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist''; }
            { command = ''${pkgs.wl-clipboard}/bin/wl-paste -p -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist''; }
            { command = ''standardnotes''; }
            { command = "${pkgs.slack}/bin/slack"; }
            { command = "${scratch-term}"; }
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

          for_window [class="Standard Notes"] move scratchpad, move position 1000 200, resize set 1800 2000
          for_window [class="Slack"] move scratchpad, move position 1000 200, resize set 1800 2000
          for_window [app_id="scratch-term"] move scratchpad, move position 1000 200, resize set 1800 2000

          assign [app_id="qutebrowser"] $ws3

          seat * hide_cursor 3000

          # Make all the pinentry stuff work
          # https://git.sr.ht/~sumner/home-manager-config/tree/master/item/modules/window-manager/wayland.nix#L64
          #exec dbus-update-activation-environment WAYLAND_DISPLAY

          exec ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway

          # Import the WAYLAND_DISPLAY env var from sway into the systemd user session.
          #exec systemctl --user import-environment WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK
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
        modules = {
          "clock" = {
            "timezone" = "America/Los_Angeles";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
          };
          "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            "format" = "{icon}";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "8" = "8";
              "9" = "9";
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
            "format-wifi " = " { essid } ({signalStrength}%) ";
            "format-ethernet" = "  {ifname}";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "⚠";
            "format-alt" = "{ifname}: { ipaddr }/{cidr}";
          };
          "pulseaudio" = {
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon}";
            "format-bluetooth-muted" = " {icon}";
            "format-muted" = " {format_source}";
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
        };
      }
    ];
    style = ''
      * {
        font-family: 'Roboto Mono for Powerline', 'UbuntuMono Nerd Font', 'SFNS Display', Helvetica, Arial, sans-serif;
        border: none;
        border-radius: 0;
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background-color: ${base02};
        border-bottom: 3px solid ${base03};
        color: #dfdfdf;
        transition-property: background-color;
        transition-duration: .5s;
      }
      #workspaces button {
        padding: 0px 14px 0px 10px;
        font-size: 16px;
        background: transparent;
        color: #dfdfdf;
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
      }
      #workspaces button.focused {
        background-color: ${base00};
        box-shadow: inset 0 -3px ${cyan};
      }
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inset 0 -3px ${violet};
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
      #tray,
      #mode,
      #custom,
      #idle_inhibitor,
      #mpd {
        padding: 0 10px;
        margin: 0 5px;
      }

      #window {
        font-size: 14px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
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
        timeout 300 '${swaylockCmd}' \
        before-sleep '${swaylockCmd}' \
        timeout 400 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
          resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
      '';
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
}
