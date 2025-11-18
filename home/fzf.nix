{ config, ... }:
let
  colors = config.my.theme.withHashTag;
in
{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--multi"
      "--reverse"
      "--info inline"
      "--bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-y:accept"
      "--height=40%"
      "--color='bg+:${colors.base01},pointer:${colors.base0C},hl+:${colors.base08},hl:${colors.base0B}'"
    ];
    fileWidgetCommand = "fd --type f";
  };

  programs.bash.initExtra = ''
    # open a file under the current directory
    bind -x '"\C-p": f() { local file=$(fzf -m --height 80%) && [[ -n $file ]] && $EDITOR $file ; }; f'
  '';
}
