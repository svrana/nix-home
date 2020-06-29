{ pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    #shortcut = "j";
    terminal = "screen-256color";
    escapeTime = 0;
    extraConfig = builtins.readFile ./tmux.conf;

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.urlview
      tmuxPlugins.open
      tmuxPlugins.copycat
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };
}
