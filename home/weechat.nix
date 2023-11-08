{ pkgs, ... }:
{
  home.packages = with pkgs; [
    weechat
  ];

  home.sessionVariables = {
    WEECHAT_HOME = "$HOME/.config/weechat";
  };

  xdg.configFile."weechat/weechat.conf".source = ./config/weechat.conf;
  xdg.configFile."weechat/irc.conf".source = ../personal/irc/irc.conf;
}
