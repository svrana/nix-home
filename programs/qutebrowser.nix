{ ... }:
{
  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile ../config/qutebrowser/config.py;
  };

  programs.bash.sessionVariables = {
    TLDEXTRACT_CACHE = "$XDG_CACHE_HOME/tldextract.cache";
  };

  xdg.dataFile."qutebrowser/userscripts/qute-pass-mod".source =
    ../config/qutebrowser/qute-pass-mod.py;
}
