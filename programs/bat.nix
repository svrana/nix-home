{ pkgs, lib, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "Monokai Extended Origin";
      #theme = "solarized";
      style = "changes";
    };

    # hmm, can't set it with solarized above?
    themes = {
          solarized = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "braver";
            repo = "Solarized"; # Bat uses sublime syntax for its themes
            rev = "87e01090cf5fb821a234265b3138426ae84900e7";
            sha256 = "01q2hn7rwccjcpgxl3xl7qrfrryhajmlkfv3mci6fbdgxnpvrg5w";
          } + "/Solarized (dark).tmTheme");
    };
  };
}
