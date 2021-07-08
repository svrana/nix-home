{ pkgs, ... }:
{
  nix = {
    trustedUsers = [ "@wheel" ];
    # Automatically optimize the Nix store to save space by hard-linking
    # identical files together. These savings add up.
    autoOptimiseStore  = true;
    # package = pkgs.nixUnstable;
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
  };
}
