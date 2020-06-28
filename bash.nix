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
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
    };
    # only run for interactive sessions
    initExtra = ''
      set -o vi
      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
      source ~/.nix-profile/etc/profile.d/nix.sh
      export DOTFILE_PLUGINS=(aws cd dircolors docker dotfiles git go gruf keychain k8s less ls powerline-go ps python pulumi rust rvm sai systemd tmux direnv)
      source ~/.dotfiles/load.sh
      setxkbmap -option caps:ctrl_modifier
    '';
    bashrcExtra = ''
    '';
    shellAliases = {
      hm = "home-manager";
    };
  };
}
