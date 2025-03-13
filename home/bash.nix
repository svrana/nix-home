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
      #source "$RCS/bash/functions.sh"
      #source "$PERSONAL/bommie.io/env.sh"
      if [ -f $PERSONAL/work/env.sh ]; then
        source $PERSONAL/work/env.sh
      fi
      if [ -f $PERSONAL/env.sh ]; then
        source $PERSONAL/env.sh
      fi

      set -o vi
      stty -ixon
    '';
    bashrcExtra = ""; # run prior to the interactive session check
    profileExtra = "";
  };
}

