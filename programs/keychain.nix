{ pkgs, lib, ... }:

{
  programs.keychain = {
    enable = true;
    keys = [
      "~/.ssh/id_rsa"
      "~/.ssh/vranix/id_rsa"
    ];
    extraFlags = [
      "--quiet"
      "--quick"
      "--dir $HOME/.config/keychain"
    ];
  };
}
