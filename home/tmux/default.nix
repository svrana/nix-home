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

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.urlview
      tmuxPlugins.open
      tmuxPlugins.copycat
      tmuxPlugins.fingers
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
    ];
  };

  programs.bash.initExtra = ''
    tmux() {
        if [ -z "$VIRTUAL_ENV" ]; then
            direnv exec / tmux attach 2>/dev/null || direnv exec / tmux
        else
            echo "Get out of virtualenv"
            return 1
        fi
    }
  '';
}
