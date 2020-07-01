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
      # fixing locale errors when running some commands (like man, rofi, etc)
      LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi
      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
      source ~/.nix-profile/etc/profile.d/nix.sh
      export DOTFILE_PLUGINS=(aws cd dircolors docker dotfiles go gruf keychain k8s less ls powerline-go ps python pulumi rust rvm sai systemd tmux)
      source ~/.dotfiles/load.sh
      setxkbmap -option caps:ctrl_modifier
    '';
    bashrcExtra = ''
    '';
    profileExtra = ''
    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
            # If not using a graphical login, then start up x ourselves
            link=$(readlink -nf /etc/systemd/system/default.target)
            if [ "$link"="/etc/systemd/system/default.target" ]; then
                    exec startx
            fi
    fi
    '';
    shellAliases = {
      hm = "home-manager";
    };
  };
}
