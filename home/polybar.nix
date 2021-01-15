{ config, pkgs, lib, ... }:
let
  polybar = config.settings.polybar;
  path = "PATH=$PATH:${pkgs.gawk}/bin:${pkgs.pulseaudio}/bin:${pkgs.bash}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.coreutils}/bin";
  base03 = "#002b36";
  base02 = "#073642";
  base01 = "#586e75";
  base00 = "#657b83";
  base0  = "#839496";
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
  services.polybar = {
    script = "${path} polybar top &";
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    config = {
      "colors" = {
        background = "${base02}";
        background-alt = "${base01}";
        foreground = "#dfdfdf";
        foreground-alt = "#555";
        primary = "#ffb52a";
        secondary = "#e60053";
        alert = "${cyan}";
      };
      "bar/top" = {
        tray-maxsize = 1000;
        width = "100%";
        height = 30;
        fixed-center = true;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line-size = 3;
        line-color = "#f00";
        border-size = 0;
        border-color = "#00000000";
        padding-right = 2;
        module-margin = 2;
        font-0 = "System San Francisco Display:style=regular:size=${polybar.font0.size}";
        font-1 = "Font Awesome:style=regular:size=${polybar.font1.size}";
        font-2 = "UbuntuMono Nerd Font Mono:style=regular:size=${polybar.font2.size}";
        modules-left = "i3";
        modules-center = "date";
        modules-right = "${polybar.modules-right}";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };
      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = "true";
        wrapping-scroll = false;
        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;";
        ws-icon-4 = "5;";
        ws-icon-5 = "6;";
        ws-icon-6 = "7;";
        ws-icon-default = "ﮆ";
        label-mode-padding = 2;
        label-mode-foreground = "#000";
        label-mode-background = "\${colors.primary}";
        label-focused = "%icon%";
        label-focused-background = "\${colors.background-alt}";
        label-focused-padding = 4;
        label-unfocused = "%icon%";
        label-unfocused-padding = "\${self.label-focused-padding}";
        label-visible = "%icon%";
        label-visible-background = "\${self.label-focused-background}";
        label-visible-padding = "\${self.label-focused-padding}";
        label-urgent = "%icon%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = "\${self.label-focused-padding}";
      };
      "module/wlan" = {
        type = "internal/network";
        interface = "${polybar.wirelessInterface}";
        interval = "3.0";
        format-connected = "<ramp-signal> <label-connected>";
        label-connected = "%essid%";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = "\${colors.foreground}";
      };
      "module/eth" = {
        type = "internal/network";
        interface = "${polybar.wiredInterface}";
        interval = "3.0";
        format-connected-prefix = " ";
        format-connected-prefix-foreground = "\${colors.foreground}";
        label-connected = "%ifname%";
        label-disconnected = " ";
        format-disconnected = "<label-disconnected>";
        label-disconnected-foreground = "\${colors.foreground}";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date-alt = "";
        date = "  %A, %b %d";
        time = "%H:%M";
        time-alt = "  %H:%M:%S";
        format-prefix-foreground = "\${colors.foreground-alt}";
        label = "%date% %time%";
      };
      "module/volume" = {
        type = "custom/script";
        tail = true;
        label-foreground = "\${colors.foreground}";
        exec = "$BIN_DIR/vol.sh --listen";
        click-left = "$BIN_DIR/vol.sh --togmute";
        scroll-up = "$BIN_DIR/vol.sh --up";
        scroll-down = "$BIN_DIR/vol.sh --down";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        full-at = "98";
        format-charging = "<label-charging>";
        label-charging = "  %percentage%%";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-full-prefix = "  ";
        format-full-prefix-foreground = "\${colors.foreground}";
        ramp-capacity-0 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-foreground = "\${colors.foreground}";
      };
      "module/powermenu"= {
        type = "custom/menu";
        expand-right = true;
        format-spacing = 1;
        label-open = "";
        label-close = "  cancel";
        label-open-foreground = "\${colors.foreground}";
        label-close-foreground = "\${colors.secondary}";
        label-separator = "|";
        label-separator-foreground = "\${colors.foreground-alt}";
        menu-0-0 = "  reboot";
        menu-0-0-exec = "sudo reboot";
        menu-0-1 = "  shutdown";
        menu-0-1-exec = "sudo shutdown";
        menu-0-2 = " logout";
        menu-0-2-exec = "i3-msg exit";
        menu-1-0 = "cancel";
        menu-1-0-exec = "menu-open-0";
      };
      "settings" = {
        screenchange-reload = true;
      };
      "global/wm" = {
        margin-top = 5;
        margin-bottom = 5;
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage:3%%";
        label-volume-foreground = "\${colors.foreground}";
        label-muted = "";
        label-muted-foreground = "\${colors.foreground}";
        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";
      };
    };
  };
}
