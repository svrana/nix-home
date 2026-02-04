{ pkgs, config, ... }:
{
  services.navidrome = { # port 4533
    enable = true;
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/var/lib/syncthing/Cloud/Music";
    };
  };
}
