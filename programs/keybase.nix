{ home, ... }:
{
  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = ".cache/keybase";
  };
  home.packages = with pkgs; [
    kbfs
    keybase
    keybase-gui
  ];
}
