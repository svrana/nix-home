{ pkgs, lib, ... }:
let
  # disable .python_history file. Might want to just move it somewhere else
  # if I start using python again.
  pythonstartup = pkgs.writeScript "python_readline" ''
    import readline
    readline.set_auto_history(False)
  '';
in
{
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [ "ignoredups" "erasedups" "ignorespace" ];
    historyFile = "$XDG_DATA_HOME/bash/history";
    shellOptions = [ "histappend" "checkwinsize" "autocd" "cdspell" ];
    # only run for interactive sessions
    initExtra = ''
      source "$RCS/functions.sh"
      #source "$PERSONAL/bommie.io/env.sh"
      #source "$PERSONAL/work/env.sh"

      set -o vi
      stty -ixon

      is() {
        if [ -z "$1" ]; then
            return
        fi

        ps -ef | head -n1 ; ps -ef | grep -v grep | grep "$@" -i --color=auto;
      }

      lsh() {
        ll | awk '{print $9}' | grep '^\.'
      }

      # hm readline module does not support moving it out of the home dir, so we manage
      # the config ourselves and bootstraped here
      # hmm, readeline says it will look at inputrc, so let's leave this out.
      #bind -f $INPUTRC
    '';
    bashrcExtra = ""; # run prior to the interactive session check
    profileExtra = "";
    shellAliases = {
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../..";
      "cdd" = "cd $DOTFILES";

      "p" = "pushd";
      "P" = "popd";

      "v" = "nvim";
      "vir" = "nvim -R -";
      "r" = "ranger";
      "pl" = "pulumi";

      "cat" = "${pkgs.bat}/bin/bat";
      "lsd" = "ls -d */";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";

      "make" = "make -j$(nproc)";

      "av" = "aws-vault";
    };
  };
}

