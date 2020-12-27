{ pkgs, ... }:
{
  home-manager.useUserPackages = true;
  home-manager.users.shaw = import ../../common.nix;
}
