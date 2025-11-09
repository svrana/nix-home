{ ... }:
{
  programs.keychain = {
    enable = true;
    extraFlags = [
      "--quiet"
      "--quick"
      "--ignore-missing"
      "--dir $HOME/.config/keychain"
    ];
    keys = [ "id_ed25519" "id_rsa" ];
  };
}
