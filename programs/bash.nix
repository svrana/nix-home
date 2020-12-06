{ pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    historySize = 100000;
    historyControl = [ "ignoredups" "erasedups" "ignorespace" ];
    historyFile = "$XDG_DATA_HOME/bash/history";
    shellOptions = [ "histappend" "checkwinsize" "autocd" "cdspell" ];
    sessionVariables = {
      AWS_VAULT_BACKEND = "pass";
      AWS_VAULT_PASS_PREFIX = "vault";
      # for docker-compose/dev/fixuid
      BUILDUID = "$(id -u $USER)";
      EDITOR = "nvim";
      MANPAGER = "nvim -c 'set ft=man' -";
      LS_DFLT_ARGS = "-hN --color=auto --group-directories-first";
      PYTHONDONTWRITEBYTECODE = 1;

      # home directory cleanup
      AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
      AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      GEM_HOME = "$XDG_DATA_HOME/gem";
      # home-manager doesn't support this until until https://github.com/nix-community/home-manager/pull/887
      #GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
      INPUTRC = "$XDG_CONFIG_HOME/inputrc";
      K9SCONFIG = "$XDG_CONFIG_HOME/k9s";
      KUBECONFIG = "$XDG_CONFIG_HOME/kube/config";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
      AWS_VAULT_PASS_PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";

      PSQLRC = "$XDG_CONFIG_HOME/psql/config";
      PYLINTHOME = "$XDG_CACHE_HOME/pylint";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
      TLDEXTRACT_CACHE = "$XDG_CACHE_HOME/tldextract.cache";
      WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WORKON_HOME = "$XDG_CACHE_HOME/virtualenvs";
      #XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      #XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";
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
      RCS = "$DOTFILES/config";
      PERSONAL = "$DOTFILES/personal";
      BIN_DIR = "$HOME/.local/bin";
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi

      hm() {
        home-manager -f "$DOTFILES/hosts/$HOSTNAME" $@
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

      # hm readline module does not support moving it out of the home dir, so we manage
      # the config ourselves and bootstraped here
      bind -f $INPUTRC

      source ${pkgs.kubectl}/share/bash-completion/completions/kubectl
      complete -F __start_kubectl k
    '';
    bashrcExtra = ''
      source "$RCS/functions.sh"
      source "$PERSONAL/synthesis/functions.sh"

      PATH_append "$BIN_DIR:$CARGO_PATH/bin"
    '';
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
      "k" = "kubectl";
      "pl" = "pulumi";
      "pass" = "gopass";

      "ls" = "ls $LS_DFLT_ARGS";
      "ll" = "ls -al";
      "lsd" = "ls -d */";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";
    };
  };
}
