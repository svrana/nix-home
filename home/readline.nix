{...}:
{
  programs.readline = {
    enable = true;
    bindings = {
      "C-l" = "clear-screen";
      "C-o"  = "source ~/.bashrc && [ -f .envrc ] && direnv reload > /dev/null 2>&1\n";
    };
    extraConfig = ''
      set editing-mode vi
    '';
  };
}
