{ pkgs, ... }:
{
  nix = {
    nixPath = import ../../nix-path.nix;
    trustedUsers = [ "@wheel" ];
    # Automatically optimize the Nix store to save space by hard-linking
    # identical files together. These savings add up.
    autoOptimiseStore = true;
    # keep-* for nix-direnv nix-shell generations
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };
}
