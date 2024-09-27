{ ... }:
let
  gemBinDir = "$HOME/.local/share/gem/bin";
in
{
  home.sessionVariables = {
    GEM_HOME = "$HOME/.local/share/gem";
    GEM_SPEC_CACHE = "$HOME/.cache/gem";
  };

  home.sessionPath = [ gemBinDir ];
}
