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
    openFirewall = true; # port 8080 (doesn't really do anything)
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true; # port 9696
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true; # port 8096, 8920
    hardwareAcceleration = {
      device = "/dev/dri/renderD128";
      type = "vaapi";
    };
  };
}
