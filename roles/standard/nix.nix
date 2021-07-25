{ pkgs, ... }:
{
  nix = {
    nixPath = import ../../nix-path.nix;
    trustedUsers = [ "@wheel" ];
    # Automatically optimize the Nix store to save space by hard-linking
    # identical files together. These savings add up.
    autoOptimiseStore  = true;
    #extraOptions = ''
    #  --experimental-features = nix-command
    #'';
  };
}
