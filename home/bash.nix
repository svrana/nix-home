{ ... }:
{
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [ "ignoredups" "erasedups" "ignorespace" ];
    historyFile = "$XDG_DATA_HOME/bash/history";
    shellOptions = [ "histappend" "checkwinsize" "autocd" "cdspell" ];
    # only run for interactive sessions
    initExtra = ''
      source "$RCS/bash/shorter.sh"

      [[ -f $PERSONAL/work/env.sh ]] && source $PERSONAL/work/env.sh
      [[ -f $PERSONAL/env.sh ]] && source $PERSONAL/env.sh

      set -o vi
      stty -ixon
    '';
    bashrcExtra = ""; # run prior to the interactive session check
    profileExtra = "";
  };
}

