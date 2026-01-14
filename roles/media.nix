{ pkgs, ... }:
{
  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    openFirewall = true; # port 7878
  };

  services.sabnzbd = {
    enable = true;
    allowConfigWrite = true;
    openFirewall = true;
    settings = {
      misc = {
        host = "0.0.0.0";
        port = 8080;
      };
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true; # port 9696
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true; # port 8096, 8920
    hardwareAcceleration = {
      enable = true;
      device = "/dev/dri/renderD128";
      type = "vaapi";
    };
  };

  services.navidrome = { # port 4533
    enable = true;
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/var/lib/syncthing/Cloud/Music";
    };
  };
}
