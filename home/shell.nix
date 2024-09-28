{ config, pkgs, lib, ... }:
{
  home = {
    sessionVariables = {
      MANPAGER = "nvim +Man!";
      TERMINAL = "${config.my.terminal.executable}";
      TMP = "/tmp";

      NIXPKGS_ALLOW_UNFREE = 1;
      NIXOS_OZONE_WL = 0; # electron apps should use wayland

      DOCKER_CONFIG = "$HOME/.config/docker";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY = "$HOME/.local/share/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
      # removal of ~/.texlive2021/
      TEXMFHOME = "$HOME/.local/share/texmf";
      TEXMFVAR = "$HOME/.cache/texlive/texmf-var";
      TEXMFCONFIG = "$HOME/.config/texlive/texmf-config";
      PULUMI_HOME = "$HOME/.config/pulumi";

      NETRC = "$HOME/.config/netrc";
      PSQLRC = "$HOME/.config/psql/config ";
      PSQL_HISTORY = "$HOME/.local/state/psql_history";
      SQLITE_HISTORY = "$HOME/.local/share/sqlite_history";
      W3M_DIR="$HOME/.config/w3m";
      WGETRC = "$HOME/.config/wget/wgetrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$HOME/.config/java";

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

      "cat" = "${lib.getExe pkgs.bat}";
      "lsd" = "ls -d */";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";

      "make" = "make -j$(nproc)";
    };
  };
}

