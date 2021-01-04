{ pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    stdlib = builtins.readFile ./direnvrc;
  };

  programs.bash.initExtra = ''
    export DIRENV_LOG_FORMAT=
  '';
}
