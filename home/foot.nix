{ config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        #term = "xterm-256color"; # seems to apply dir-colors afterwards, though messes up when loading vim in tmux
        font = config.settings.foot.font;
        #dpi-aware="yes";
      };
    };
  };
}
