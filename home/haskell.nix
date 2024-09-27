{ ... }:
{
  home.file.".haskeline".text = ''
    editMode: Vi
    historyDuplicates: IgnoreConsecutive
    bellStyle: NoBell
  '';

  home.sessionVariables = {
    CABAL_HOME = "$HOME/.local/share/cabal";
  };
}
