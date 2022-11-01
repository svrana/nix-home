{ pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    # sensible adds some config I don't like if I set the shortcut here
    #shortcut = "j";
    terminal = "xterm-256color";
    escapeTime = 0;
    extraConfig = builtins.readFile ./tmux.conf;

    plugins = with pkgs.tmuxPlugins; [
      yank
      urlview
      open
      copycat
      fingers
      sessionist
      extrakto
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };
}
