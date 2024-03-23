{ config, ... }:
let
  colors = config.settings.theme.withHashTag;
in
{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--multi"
      "--reverse"
      "--info inline"
      "--bind=ctrl-f:page-down,ctrl-b:page-up"
      "--height=40%"
      "--color='bg+:${colors.base01},pointer:${colors.base0C},hl+:${colors.base08},hl:${colors.base0B}'"
    ];
    fileWidgetCommand = "fd --type f";
  };

  programs.bash.initExtra = ''
    # open a file under the current directory
    bind -x '"\C-p": f() { local file=$(fzf -m --height 80%) && [[ -n $file ]] && $EDITOR $file ; }; f'

    # open a dotfile
    bind -x '"\C-n": f() { pushd $DOTFILES > /dev/null ; local file=$(fzf -m --height 80% --preview "bat --style=numbers --color=always --line-range :100 {}") && [[ -n $file ]] && $EDITOR $file ; popd > /dev/null ; }; f'

    # open a file under the current (git) project root
    bind -x '"\C-f": f() { pushd $(git_root) > /dev/null ; local file=$(fzf -m --height 80%) && [[ -n $file ]] && $EDITOR $file ; popd > /dev/null ; }; f'
  '';
}
