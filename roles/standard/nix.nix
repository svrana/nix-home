{ pkgs, ... }:
{
  nix = {
    trustedUsers = [ "@wheel" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
