{ pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    stdlib = builtins.readFile ./direnvrc;
    nix-direnv.enable = true;
  };

  programs.bash.initExtra = ''
    export DIRENV_LOG_FORMAT=
  '';
}
