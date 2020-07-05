{ pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [
      "ignoredups"
    ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "autocd"
      "cdspell"
    ];
    sessionVariables = {
      MANPAGER = "nvim -c 'set ft=man' -";
      EDITOR = "nvim";
      TERM = "xterm-256color";
      # for docker-compose/dev/fixuid
      BUILDUID = "$(id -u $USER)";
      LS_DFLT_ARGS = "-hN --color=auto --group-directories-first";
      WORKON_HOME = "~/.virtualenvs";
      PYTHONDONTWRITEBYTECODE = 1;
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi

      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

    

      # Move this to proper config file
      setxkbmap -option caps:ctrl_modifier

      bind '"":"source ~/.bashrc && direnv reload > /dev/null 2>&1\n"'


      hm() {
        home-manager -f "$DOTFILES/hosts/$HOSTNAME.nix" $@
      }

      is() {
        if [ -z "$1" ]; then
            return
        fi

        ps -ef | head -n1 ; ps -ef | grep -v grep | grep "$@" -i --color=auto;
      }

      lsh() {
        ll | awk '{print $9}' | grep '^\.'
      }

      _update_ps1() {
        local priority='root,perms,venv,git-branch,exit,cwd'
        local modules='perms,venv,gitlite,ssh,cwd,exit'

        PS1="$(powerline-go -cwd-mode dironly -theme default -modules $modules \
          -priority $priority -cwd-max-depth 1 -max-width 65 \
          -path-aliases \~/go/src/github.com=@go-gh)"
      }
      PROMPT_COMMAND="_update_ps1 ; $PROMPT_COMMAND"
    '';
    bashrcExtra = ''
      export CARGO_PATH=~/.cargo
      export TMP=/tmp
      export CLOUD_ROOT=~/Cloud
      export PHOTOS=~/Pictures
      export DOCUMENTS=~/Documents
      export DOWNLOADS=~/Downloads
      export MUSIC=~/Music
      export PROJECTS=~/Projects
      export APPS=~/Apps
      export DOTFILES=~/.dotfiles
      export RCS="$DOTFILES/config"
      export BIN_DIR=~/.local/bin

      source "$RCS/functions.sh"

      PATH_append "$BIN_DIR:$DOTFILES/scripts:~/.pulumi/bin:$CARGO_PATH/bin"
    '';
    profileExtra = ''
    # programs launched without a terminal still need nix profile/bin in their path
    source ~/.nix-profile/etc/profile.d/nix.sh

    complete -F __start_kubectl k


    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
            # If not using a graphical login, then start up x ourselves
            link=$(readlink -nf /etc/systemd/system/default.target)
            if [ "$link"="/etc/systemd/system/default.target" ]; then
                    exec startx
            fi
    fi
    '';
    shellAliases = {
      "cd.." = "cd ..";
      ".."   = "cd ..";
      "..."  = "cd ../../";
      "...." = "cd ../../..";
      "cdd"  = "cd $DOTFILES";

      "p" = "pushd";
      "P="= "popd";

      "k" = "kubectl";
      "pl" = "pulumi";

      "ls" = "ls \$LS_DFLT_ARGS";
      "ll" = "ls -al";
      "lsd" = "ls -d */";

      "sctl" = "sudo systemctl";
      "jctl" = "sudo journalctl";
      "nctl" = "sudo networkctl";
    };
  };
}
