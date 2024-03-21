{ config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        #term = "xterm-256color"; # seems to apply dir-colors afterwards, though messes up when loading vim in tmux
        font = config.settings.terminal.font;
        #dpi-aware="yes";
      };
      # these are the defaults (which are based on solarized-dark which I use elsewhere, but there's talk of changing
      # the defaults to something else, so we go ahead and set them manually.
      colors = {
        background="002b36";
        foreground="839496";

        regular0="073642";
        regular1="dc322f";
        regular2="859900";
        regular3="b58900";
        regular4="268bd2";
        regular5="d33682";
        regular6="2aa198";
        regular7="eee8d5";


        bright0="08404f";
        bright1="e35f5c";
        bright2="9fb700";
        bright3="d9a400";
        bright4="4ba1de";
        bright5="dc619d";
        bright6="32c1b6";
        bright7="ffffff";
      };
      key-bindings = {
        unicode-input = "Control+Shift+o";
        show-urls-launch = "Control+Shift+u";
      };
    };
  };
}
