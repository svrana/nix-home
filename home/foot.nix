{ config, ... }:
let
  colors = config.settings.theme;
in
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
        background=colors.base00;
        foreground=colors.base04;

        regular0=colors.base01;
        regular1=colors.base08;
        regular2=colors.base0B;
        regular3=colors.base0A;
        regular4=colors.base0D;
        regular5=colors.base0F;
        regular6=colors.base0C;
        regular7=colors.base07;

        bright0="08404f";
        bright1="e35f5c";
        bright2="9fb700";
        bright3="d9a400";
        bright4=colors.base0D;
        bright5=colors.base0F;
        bright6=colors.base0C;
        bright7="ffffff";
      };
      key-bindings = {
        unicode-input = "Control+Shift+o";
        show-urls-launch = "Control+Shift+u";
      };
    };
  };
}
