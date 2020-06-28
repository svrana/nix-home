{ pkgs, lib, ... }:

{
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-d:page-up"
    ];
    fileWidgetCommand = "fd --type f";
  };

  programs.bash.initExtra = ''
    bind -x '"\C-p": f() { local file=$(fzf -m --height 80% --reverse) && [[ -n $file ]] && nvim $file ; }; f'
    bind -x '"\C-n": f() { pushd $DOTFILES > /dev/null ; local file=$(fzf -m --height 80% --reverse) && [[ -n $file ]] && nvim $file ; popd > /dev/null ; }; f'
  '';
}
