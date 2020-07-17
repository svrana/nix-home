{ pkgs, lib, ... }:

{
  programs.keychain = {
    enable = true;
    extraFlags = [
      "--quiet"
      "--quick"
      "--dir $HOME/.config/keychain"
    ];
  };
}
