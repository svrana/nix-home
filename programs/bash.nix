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
      LS_DFLT_ARGS="-hN --color=auto --group-directories-first";
      WORKON_HOME="~/.virtualenvs";
      PYTHONDONTWRITEBYTECODE = 1;
      CARGO_PATH = "~/.cargo";
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi

      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

      export DOTFILE_PLUGINS=(gruf rust)
      source ~/.dotfiles/load.sh

      # Move this to proper config file
      setxkbmap -option caps:ctrl_modifier

      bind '"":"source ~/.bashrc && direnv reload > /dev/null 2>&1\n"'

      PATH_append "$HOME/.pulumi/bin"
      PATH_append "$CARGO_PATH/bin"

      hm() {
        home-manager -f "$PROJECTS/nix-home/hosts/$HOSTNAME.nix" $@
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
    '';
    profileExtra = ''
    # programs launched without a terminal still need nix profile/bin in their path
    source ~/.nix-profile/etc/profile.d/nix.sh

    export TMP=/tmp
    export CLOUD_ROOT=~/Cloud
    export PHOTOS=~/Pictures
    export DOCUMENTS=~/Documents
    export DOWNLOADS=~/Downloads
    export MUSIC=~/Music
    export PROJECTS=~/Projects
    export APPS=~/Apps

    complete -F __start_kubectl k

    is() {
        if [ -z "$1" ]; then
            return
        fi

        ps -ef | head -n1 ; ps -ef | grep -v grep | grep "$@" -i --color=auto;
    }

    lsh() {
        ll | awk '{print $9}' | grep '^\.'
    }

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
