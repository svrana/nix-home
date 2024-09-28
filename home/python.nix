{ pkgs, ... }:
let
  # disable .python_history file. Might want to just move it somewhere else
  # if I start using python again.
  pythonstartup = pkgs.writeScript "python_readline" ''
    import readline
    readline.set_auto_history(False)
  '';
in
{
  home.packages = [
    pkgs.python3
  ];

  home.sessionVariables = {
    PYLINTHOME = "$HOME/.cache/pylint ";
    PYTHONSTARTUP = "${pythonstartup}";
    PYTHONDONTWRITEBYTECODE = 1;
  };
}
