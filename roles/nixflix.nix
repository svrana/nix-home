{ pkgs, config, ... }:
{
  sops.secrets = {
    "sonarr/api_key" = {};
    "sonarr/password" = {};
    "radarr/api_key" = {};
    "radarr/password" = {};
    "lidarr/api_key" = {};
    "lidarr/password" = {};
    "prowlarr/api_key" = {};
    "prowlarr/password" = {};
    "indexer-api-keys/nzbgeek" = {};
    "jellyfin/shaw_password" = {};
    "jellyseerr/api_key" = {};
    "sabnzbd/api_key" = {};
    "sabnzbd/nzb_key" = {};
    "usenet/newshosting/username" = {};
    "usenet/newshosting/password" = {};
  };

  nixflix = {
    enable = true;
    mediaDir = "/media";
    stateDir = "/media/.state";
    mediaUsers = [ "shaw" ];

    theme = {
      enable = true;
      name = "overseerr";
    };

    nginx.enable = true;
    postgres.enable = false;

    sonarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."sonarr/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."sonarr/password".path; };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."radarr/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."radarr/password".path; };
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = true;
    };

    lidarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."lidarr/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."lidarr/password".path; };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."prowlarr/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."prowlarr/password".path; };
        indexers = [
          {
            name = "NZBGeek";
            apiKey = { _secret = config.sops.secrets."indexer-api-keys/nzbgeek".path; };
          }
        ];
      };
    };

    sabnzbd = {
      enable = true;

      settings = {
        misc = {
          api_key = { _secret = config.sops.secrets."sabnzbd/api_key".path; };
          nzb_key = { _secret = config.sops.secrets."sabnzbd/nzb_key".path; };
        };

        servers = [
          {
            name = "newshosting";
            host = "news.newshosting.com";
            port = 563;
            # Secrets use { _secret = /path; } syntax
            username = { _secret = config.sops.secrets."usenet/newshosting/username".path; };
            password = { _secret = config.sops.secrets."usenet/newshosting/password".path; };
            connections = 20;
            ssl = true;
            priority = 0;
            retention = 3000;
          }
        ];
      };
    };

    jellyfin = {
      enable = true;
      encoding = {
        enableHardwareEncoding = true;
        hardwareAccelerationType = "vaapi";
        vaapiDevice = "/dev/dri/renderD128";
      };
      users = {
        shaw = {
          mutable = false;
          policy.isAdministrator = true;
          password = { _secret = config.sops.secrets."jellyfin/shaw_password".path; };
        };
      };
    };

    jellyseerr = {
      enable = true;
      apiKey = { _secret = config.sops.secrets."jellyseerr/api_key".path; };
    };
  };
}
