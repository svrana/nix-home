{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
  };

  # todo convert
  xdg.configFile."dunst/dunstrc" = {
    text = ''
      # the [global] flag is added by the home-manager so excluded here
      #[global]
        geometry = "500x50-30+35"
        indicate_hidden = yes
        shrink = no
        separator_height = 4
        padding = 16
        horizontal_padding = 16
        frame_width = 2
        frame_color = "#93a1a1"

        separator_color = frame
        sort = yes
        idle_threshold = 0

        font = System San Francisco Display "${toString config.settings.dunstFontSize}"
        line_height = 4
        markup = full

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        #   %n  progress value if set without any extra characters
        # Markup is allowed
        format = "<b>%s</b>\n%b"
        alignment = left
        show_age_threshold = 60
        word_wrap = yes
        ignore_newline = no
        stack_duplicates = false
        hide_duplicate_count = false
        show_indicators = yes

        # Align icons left/right/off
        icon_position = left
        max_icon_size = 128


      [urgency_low]
        background = "#002b36"
        foreground = "#b58900"
        timeout = 2

      [urgency_normal]
        background = "#002b36"
        foreground = "#d33682"
        timeout = 4

      [urgency_critical]
        background = "#002b36"
        foreground = "#d33682"
        timeout = 4

      [Spotify]
        appname = Spotify
        format = "<b>Now Playing</b>\n%s\n%b"
        timeout = 8
    '';
  };
}
