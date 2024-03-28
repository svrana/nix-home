{...}:
{
  xdg.configFile."inputrc".source = ./config/inputrc;

  programs.readline = {
    enable = false;
    bindings = {
      "\\C-l" = "clear-screen";
      "\\C-o"  = "source ~/.bashrc && [ -f .envrc ] && direnv reload > /dev/null 2>&1\n" || true;
    };
    extraConfig = ''
      set show-mode-in-prompt on
      set vi-ins-mode-string "\1\e[2 q\2"
      set vi-cmd-mode-string "\1\e[6 q\2"
      set editing-mode vi
    '';
  };
}
