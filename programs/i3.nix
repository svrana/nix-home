{ config, pkgs, lib, ... }:

{
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    importedVariables = [
      "INPUTRC"
      "DOTFILES"
      "RCS"
      "BIN_DIR"
    ];
    # oddly this breaks i3-gaps if changed
    #scriptPath = ".config/X11/xsession-hm";
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        #extraPackages = with pkgs; [
        # autotiling
        #];
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
          bars = [ ];
          window = { hideEdgeBorders = "smart"; };
          focus = {
            followMouse = false;
            newWindow = "focus";
          };
          #menu = "rofi -show drun -modi drun,run -eh 2 -padding 16 -show-icons";
          fonts = [ "System San Francisco Display 12" ];
          colors = {
            focused = {
              border = "#4c7899";
              background = "$base01";
              text = "#ffffff";
              indicator = "$blue";
              childBorder = "$cyan";
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
              background = "$base02";
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
          keybindings = let mod = "Mod4";
          in {
            "${mod}+Shift+minus" = "move scratchpad";
            "${mod}+minus" = "scratchpad show";
            "${mod}+Return" = "exec --no-startup-id alacritty";
            "${mod}+Shift+q" = "kill";
            "${mod}+q" = "kill";
            "${mod}+d" = ''exec --no-startup-id "rofi -show drun -modi drun,run -eh 2 -padding 16 -show-icons"'';
            "${mod}+Tab" = ''exec --no-startup-id "rofi -show window -eh 2 -padding 16 -show-icons"'';
            "${mod}+u" = ''exec --no-startup-id "alacritty -e ranger"'';
            "${mod}+x" = "layout toggle splitv splith";
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+p" = ''exec --no-startup-id "gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show"'';
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+s" = "layout stacking";
            "${mod}+t" = "layout tabbed";
            "${mod}+e" = "layout toggle split";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+a" = "focus parent";
            "${mod}+Shift+t" = "exec --no-startup-id alacritty --class tmux -e tmuxinator work";
            "${mod}+1" = "workspace 1";
            "${mod}+2" = "workspace 2";
            "${mod}+3" = "workspace 3";
            "${mod}+4" = "workspace 4";
            "${mod}+5" = "workspace 5";
            "${mod}+6" = "workspace 6";
            "${mod}+7" = "workspace 7";
            "${mod}+Shift+1" = "move container to workspace 1";
            "${mod}+Shift+2" = "move container to workspace 2";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";
            "${mod}+Shift+5" = "move container to workspace 5";
            "${mod}+Shift+6" = "move container to workspace 6";
            "${mod}+Shift+7" = "move container to workspace 7";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+r" = "mode resize";
            "${mod}+i" = "mode split";
            "${mod}+n" = ''[instance="aerc"] focus'';
            "${mod}+m" = ''[instance="tmux"] focus'';
            "${mod}+comma" = ''[class="qutebrowser"] focus'';
            "${mod}+period" = ''[instance="spotify"] focus'';
            "${mod}+0" = ''[class="Standard Notes"] scratchpad show'';
            "${mod}+9" = ''[class="Slack"] scratchpad show'';
            "${mod}+Shift+e" = "mode exit: l)ogout r)eboot s)hutdown su)spend h)ibernate n)etworking restart";
            "Mod1+Control+l" = "exec --no-startup-id $BIN_DIR/i3lockwrapper.sh";
            "Mod1+Control+t" = "exec --no-startup-id alacritty";
            "Mod1+Control+v" = "split horizontal";
            "Mod1+Control+h" = "split vertical";
            "Mod1+Control+u" = "exec --no-startup-id $BIN_DIR/vol.sh --up";
            "Mod1+Control+d" = "exec --no-startup-id $BIN_DIR/vol.sh --down";
            "Mod1+Control+m" = "exec --no-startup-id $BIN_DIR/vol.sh --togmute";
            "XF86AudioRaiseVolume" = "exec --no-startup-id $BIN_DIR/vol.sh --up";
            "XF86AudioLowerVolume" = "exec --no-startup-id $BIN_DIR/vol.sh --down";
            "XF86AudioMute" = "exec --no-startup-id $BIN_DIR/vol.sh --togmute";
            "XF86AudioPlay" = "exec --no-startup-id playerctl play";
            "XF86AudioPause" = "exec --no-startup-id playerctl pause";
            "XF86AudioNext" = "exec --no-startup-id playerctl next";
            "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
            "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc 20";
            "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec 20";
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
            split = {
              "v" = "mode default, split horizontal";
              "h" = "mode default, split vertical";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
            "exit: l)ogout r)eboot s)hutdown su)spend h)ibernate n)etworking restart" = {
              "l" = "exec i3-msg exit";
              "r" = "exec sudo systemctl reboot";
              "s" = "exec sudo systemctl poweroff";
              "u" = "exec sudo systemctl suspend";
              "n" = "exec sudo systemctl restart NetworkManager ; mode default";
              "h" = "exec sudo systemctl hibernate; mode default";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };
          startup = [
            { command = "$BIN_DIR/autotiling-launch.sh"; notification = false; always = true; }
            { command = "systemctl --user restart polybar"; always = true; notification = false; }
            { command = "insync start"; notification = false; }
            { command = "dunst"; notification = false; }
            { command = "xautolock -corners '--00' -time 5 -locker $BIN_DIR/i3lockwrapper.sh"; notification = false; }
            { command = "hsetroot -solid '#002b36'"; notification = false; }
            { command = "qutebrowser"; notification = false; }
            { command = "standardnotes"; notification = false; }
            { command = "slack"; notification = false; }
          ];
        };
        extraConfig = ''
                  set $ws1 1
                  set $ws2 2
                  set $ws3 3
                  set $ws4 4
                  set $ws5 5
                  set $ws6 6

                  set $base03 #002b36
                  set $base02 #073642
                  set $base01 #586e75
                  set $base00 #657b83
                  set $base0 #839496
                  set $base1 #93a1a1
                  set $base2 #eee8d5
                  set $base3 #fdf6e3
                  set $yellow #b58900
                  set $orange #cb4b16
                  set $red #dc322f
                  set $magenta #d33682
                  set $violet #6c71c4
                  set $blue #268bd2
                  set $cyan #2aa198
                  set $green #859900

                  default_border pixel 2

                  for_window [class="Standard Notes"] move scratchpad, move position 1000 50, resize set 1800 2000
                  for_window [class="Slack"] move scratchpad, move position 1000 50, resize set 1800 2000

                  assign [class="qutebrowser"] $ws3
        '';
      };
    };
  };
}