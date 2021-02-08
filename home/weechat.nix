{ pkgs, ... }:
{
  home.packages = with pkgs; [
    weechat
  ];

  programs.bash.sessionVariables = {
    WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
  };

  xdg.configFile."weechat/weechat.conf".source = ./config/weechat.conf;
  xdg.configFile."weechat/irc.conf".source = ../personal/irc/irc.conf;
}
