{ pkgs, ... }:
{
  home.packages = with pkgs; [
    weechat
  ];

  programs.bash.sessionVariables = {
    WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
  };
}
