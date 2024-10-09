{...}:
{
  programs.readline = {
    enable = true;
    # example how to set keybindings in inserts and command mode. Note that I'm ctrl-l to move in tmux terminal
    # so doesn't work there.
    extraConfig = ''
      set editing-mode vi
      $if mode=vi
        set keymap vi-command
        Control-l: clear-screen
        set keymap vi-insert
        Control-l: clear-screen
      $endif
    '';
  };
}
