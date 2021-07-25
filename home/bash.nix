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
    sessionVariables = {
      # for docker-compose/dev/fixuid
      BUILDUID = "$(id -u $USER)";
      EDITOR = "vim";
      MANPAGER = "vim -c 'set ft=man' -";
      LS_DFLT_ARGS = "-hN --color=auto --group-directories-first";
      TERMINAL = "${pkgs.alacritty}/bin/alacritty --config-file /home/shaw/.config/alacritty/alacritty.yml -e";

      NIXPKGS_ALLOW_UNFREE = 1;
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      GEM_HOME = "$XDG_DATA_HOME/gem";
      # home-manager doesn't support this until until https://github.com/nix-community/home-manager/pull/887
      #GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
      INPUTRC = "$XDG_CONFIG_HOME/inputrc";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";

      MINIKUBE_HOME = "$XDG_CONFIG_HOME/minikube";
      TILT_DEV_DIR = "$XDG_CONFIG_HOME/tilt";

      PSQLRC = "$XDG_CONFIG_HOME/psql/config";
      PYLINTHOME = "$XDG_CACHE_HOME/pylint";
      PYTHONSTARTUP="${pythonstartup}";
      PYTHONDONTWRITEBYTECODE = 1;
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WORKON_HOME = "$XDG_CACHE_HOME/virtualenvs";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";

      TMP = "/tmp";
      CLOUD_ROOT = "$HOME/Cloud";
      PHOTOS = "$HOME/Pictures";
      DOCUMENTS = "$HOME/Documents";
      DOWNLOADS = "$HOME/Downloads";
      MUSIC = "$HOME/Music";
      PROJECTS = "$HOME/Projects";
      APPS = "$HOME/Apps";
      DOTFILES = "$HOME/Projects/dotfiles";
      RCS = "$DOTFILES/home/config";
      PERSONAL = "$DOTFILES/personal";
      BIN_DIR = "$HOME/.local/bin";
    };
    # only run for interactive sessions
    initExtra = ''
      source "$RCS/functions.sh"
      PATH_append "$BIN_DIR"

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
      bind -f $INPUTRC
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
      "r" = "ranger";
      "pl" = "pulumi";

      "ls" = "ls $LS_DFLT_ARGS";
      "ll" = "ls -al";
      "lsd" = "ls -d */";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";
    };
  };
}
