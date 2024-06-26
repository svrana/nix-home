{ config, ... }:
let
  colors = config.my.theme.withHashTag;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        #geometry = "500x50-30+35";
        #origin = "top,right";
        width = "400";
        height = "10000";
        offset = "50x30";
        #notification_height = 35;
        indicate_hidden = "yes";
        shrink = "no";
        separator_height = 4;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 2;
        frame_color = colors.base0C;

        separator_color = "frame";
        sort = "yes";
        idle_threshold = 0;
        font = "System San Francisco Display ${toString config.my.dunst.fontSize}";
        line_height = 4;
        markup = "full";
        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        #   %n  progress value if set without any extra characters
        # Markup is allowed
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = false;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        max_icon_size = 128;
      };
      urgency_low = {
        background = colors.base00;
        foreground = colors.base0A;
        timeout = 2;
      };
      urgency_normal = {
        background = colors.base00;
        foreground = colors.base0F;
        timeout = 4;
      };
      urgency_critical = {
        background = colors.base00;
        foreground = colors.base0F;
        timeout = 4;
      };
      Spotify = {
        appname = "Spotify";
        format = "<b>Now Playing</b>\\n%s\\n%b";
        timeout = 8;
      };
    };
  };
}
