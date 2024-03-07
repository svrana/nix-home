{ ... }:
{
  programs.bash.initExtra = ''
    source "$PROJECTS/gruf/gruf.sh"
  '';
}
