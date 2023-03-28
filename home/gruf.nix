{ pkgs, lib, ... }:

{
  # programs.fzf = {
  #   enable = true;
  #   defaultCommand = "fd --type f";
  #   defaultOptions = [
  #     "--bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-d:page-up"
  #   ];
  #   fileWidgetCommand = "fd --type f";
  # };

  programs.bash.initExtra = ''
    source "$PROJECTS/gruf/gruf.sh"
  '';
}
