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
  home.sessionVariables = {
      # for docker-compose/dev/fixuid
      #BUILDUID = "$(id -u $USER)";
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";

      #TERMINAL = "${pkgs.alacritty}/bin/alacritty --config-file /home/shaw/.config/alacritty/alacritty.yml -e";
      TERMINAL = "${pkgs.foot}/bin/foot";
      RANGER_ZLUA = "${pkgs.z-lua}/bin/z.lua";

      NIXPKGS_ALLOW_UNFREE = 1;
      #NIXOS_OZONE_WL = 0; # electron apps should use wayland
      CABAL_HOME = "$XDG_DATA_HOME/cabal";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      DOCKER_BUILDKIT = 1;
      GEM_HOME = "$XDG_DATA_HOME/gem";
      GEM_SPEC_CACHE = "$XDG_CACHE_HOME/gem";
      INPUTRC = "$XDG_CONFIG_HOME/inputrc";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      # removal of ~/.texlive2021/
      TEXMFHOME = "$XDG_DATA_HOME/texmf";
      TEXMFVAR = "$XDG_CACHE_HOME/texlive/texmf-var";
      TEXMFCONFIG = "$XDG_CONFIG_HOME/texlive/texmf-config";
      MINIKUBE_HOME = "$XDG_CONFIG_HOME/minikube";
      PULUMI_HOME = "$XDG_CONFIG_HOME/pulumi";
      TILT_DEV_DIR = "$XDG_CONFIG_HOME/tilt";
      HISTFILE = "$XDG_STATE_HOME/bash_history";
      XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose";
      XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";

      NETRC = "$XDG_CONFIG_HOME/netrc ";
      PSQLRC = "$XDG_CONFIG_HOME/psql/config ";
      PSQL_HISTORY = "$XDG_STATE_HOME/psql_history";
      PYLINTHOME = "$XDG_CACHE_HOME/pylint ";
      PYTHONSTARTUP = "${pythonstartup}";
      PYTHONDONTWRITEBYTECODE = 1;
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
      WORKON_HOME = "$XDG_CACHE_HOME/virtualenvs";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
      _ZL_DATA = "$XDG_CACHE_HOME/zlua";

      TMP = "/tmp";
      CLOUD_ROOT = "$HOME/Cloud";
      PHOTOS = "$HOME/Pictures";
      DOCUMENTS = "$HOME/Documents";
      DOWNLOADS = "$HOME/Downloads";
      MUSIC = "$HOME/Music";
      PROJECTS = "$HOME/Projects";
      DOTFILES = "$HOME/Projects/dotfiles";
      RCS = "$DOTFILES/home/config";
      PERSONAL = "$DOTFILES/personal";
      BIN_DIR = "$HOME/.local/bin";
      SCRIPTS = "$DOTFILES/home/scripts";
      DOOMDIR = "$HOME/.config/doom";
  };
}

