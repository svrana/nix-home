{ pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [
      "ignoredups"
      "erasedups"
      "ignorespace"
    ];
    historyFile = "$XDG_DATA_HOME/bash/history";
    shellOptions = [
      "histappend"
      "checkwinsize"
      "autocd"
      "cdspell"
    ];
    sessionVariables = {
      AWS_VAULT_BACKEND = "pass";
      AWS_VAULT_PASS_PREFIX = "vault";
      # for docker-compose/dev/fixuid
      BUILDUID = "$(id -u $USER)";
      EDITOR = "nvim";
      MANPAGER = "nvim -c 'set ft=man' -";
      TERM = "xterm-256color";
      LS_DFLT_ARGS = "-hN --color=auto --group-directories-first";
      PYTHONDONTWRITEBYTECODE = 1;

      # home directory cleanup
      AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
      AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      DOCKER_CONFIG="$XDG_CONFIG_HOME/docker";
      GEM_HOME = "$XDG_DATA_HOME/gem";
      GNUPGHOME="$XDG_DATA_HOME/gnupg";
      GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
      INPUTRC = "$XDG_CONFIG_HOME/inputrc";
      K9SCONFIG = "$XDG_CONFIG_HOME/k9s";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
      AWS_VAULT_PASS_PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";

      PSQLRC = "$XDG_CONFIG_HOME/psql/config";
      PYLINTHOME = "$XDG_CACHE_HOME/pylint";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
      WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WORKON_HOME = "$XDG_CACHE_HOME/virtualenvs";
      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi

      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

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
          -priority $priority -max-width 65)"
      }
      PROMPT_COMMAND="_update_ps1 ; $PROMPT_COMMAND"

      # hmmmmm, why do i have to do this by hand?
      bind -f $INPUTRC
    '';
    bashrcExtra = ''
      export TMP=/tmp
      export CLOUD_ROOT=~/Cloud
      export PHOTOS=~/Pictures
      export DOCUMENTS=~/Documents
      export DOWNLOADS=~/Downloads
      export MUSIC=~/Music
      export PROJECTS=~/Projects
      export APPS=~/Apps
      export DOTFILES=~/Projects/dotfiles
      export RCS="$DOTFILES/config"
      export PERSONAL="$DOTFILES/personal"
      export BIN_DIR=~/.local/bin

      source "$RCS/functions.sh"
      source "$PERSONAL/synthesis/functions.sh"

      PATH_append "$BIN_DIR:$HOME/.pulumi/bin:$CARGO_PATH/bin"
    '';
    profileExtra = ''
    # programs launched without a terminal still need nix profile/bin in their path
    source ~/.nix-profile/etc/profile.d/nix.sh

    complete -F __start_kubectl k

    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
            # If not using a graphical login, then start up x ourselves
            link=$(readlink -nf /etc/systemd/system/default.target)
            if [ "$link"="/etc/systemd/system/default.target" ]; then
                    exec startx "$XDG_CONFIG_HOME/X11/xinitrc" -- "$XDG_CONFIG_HOME/X11/xserverrc" vt1
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
      "P"= "popd";

      "v" = "nvim";
      "k" = "kubectl";
      "pl" = "pulumi";
      "pass" = "gopass";

      "ls" = "ls \$LS_DFLT_ARGS";
      "ll" = "ls -al";
      "lsd" = "ls -d */";

      "sctl" = "sudo systemctl";
      "jctl" = "sudo journalctl";
      "nctl" = "sudo networkctl";
    };
  };
}
