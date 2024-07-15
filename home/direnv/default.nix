{ ... }:

{
  programs.direnv = {
    enable = true;
    stdlib = builtins.readFile ./direnvrc;
    nix-direnv.enable = true;
    silent = true;
  };
}
