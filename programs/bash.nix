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
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi

      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

      export DOTFILE_PLUGINS=(cd docker dotfiles gruf keychain k8s less ls powerline-go ps python pulumi rust rvm sai systemd)
      source ~/.dotfiles/load.sh
      setxkbmap -option caps:ctrl_modifier
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
      "cd.." = "cd ..";
      ".."   = "cd ..";
      "..."  = "cd ../../";
      "...." = "cd ../../..";
    };
  };
}
