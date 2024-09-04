{ config, pkgs, ... }:
let
  # disable .python_history file. Might want to just move it somewhere else
  # if I start using python again.
  pythonstartup = pkgs.writeScript "python_readline" ''
    import readline
    readline.set_auto_history(False)
  '';
in
{
  home = {
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      TERMINAL = "${config.my.terminal.executable}";

      NIXPKGS_ALLOW_UNFREE = 1;
      NIXOS_OZONE_WL = 0; # electron apps should use wayland
      CABAL_HOME = "$HOME/.local/share/cabal";
      CARGO_HOME = "$HOME/.local/share/cargo";
      DOCKER_CONFIG = "$HOME/.config/docker";
      DOCKER_BUILDKIT = 1;
      GEM_HOME = "$HOME/.local/share/gem";
      GEM_SPEC_CACHE = "$HOME/.cache/gem";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$HOME/.local/share/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
      # removal of ~/.texlive2021/
      TEXMFHOME = "$HOME/.local/share/texmf";
      TEXMFVAR = "$HOME/.cache/texlive/texmf-var";
      TEXMFCONFIG = "$HOME/.config/texlive/texmf-config";
      PULUMI_HOME = "$HOME/.config/pulumi";
      TILT_DEV_DIR = "$HOME/.config/tilt";
      HISTFILE = "$HOME/.local/state/bash_history";

      NETRC = "$HOME/.config/netrc";
      PSQLRC = "$HOME/.config/psql/config ";
      PSQL_HISTORY = "$HOME/.local/state/psql_history";
      PYLINTHOME = "$HOME/.cache/pylint ";
      PYTHONSTARTUP = "${pythonstartup}";
      PYTHONDONTWRITEBYTECODE = 1;
      RUSTUP_HOME = "$HOME/.local/share/rustup";
      SQLITE_HISTORY = "$HOME/.local/share/sqlite_history";
      W3M_DIR="$HOME/.config/w3m";
      WGETRC = "$HOME/.config/wget/wgetrc";
      WORKON_HOME = "$HOME/.cache/virtualenvs";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$HOME/.config/java";

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
    };

    shellAliases = {
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../..";
      "cdd" = "cd $DOTFILES";

      "p" = "pushd";
      "P" = "popd";

      "v" = "nvim";
      "svi" = "sudo vi";
      "vir" = "nvim -R -";
      "pl" = "pulumi";

      "cat" = "${pkgs.bat}/bin/bat";
      "lsd" = "ls -d */";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";

      "make" = "make -j$(nproc)";

      "path"= "echo -e \${PATH//:/\\n}";
    };
};
}

