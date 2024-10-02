{ pkgs, ... }:
{
  home.packages = [
    pkgs.python3
  ];

  home.sessionVariables = {
    PYLINTHOME = "$HOME/.cache/pylint ";
    PYTHONDONTWRITEBYTECODE = 1;
    PYTHON_HISTORY = "$HOME/.local/state/python/history";
    WORKON_HOME = "$HOME/.cache/virtualenvs";
  };
}
