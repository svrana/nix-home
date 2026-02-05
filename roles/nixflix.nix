{ pkgs, config, ... }:
{
  sops.secrets = {
    "media/password" = {};
    "media/api_key" = {};
    "indexer-api-keys/nzbgeek" = {};
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
        apiKey = { _secret = config.sops.secrets."media/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."media/password".path; };
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."media/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."media/password".path; };
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = true;
    };

    lidarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."media/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."media/password".path; };
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey = { _secret = config.sops.secrets."media/api_key".path; };
        hostConfig.password = { _secret = config.sops.secrets."media/password".path; };
        indexers = [
          {
            name = "NZBgeek";
            apiKey = { _secret = config.sops.secrets."indexer-api-keys/nzbgeek".path; };
          }
        ];
      };
    };

    sabnzbd = {
      enable = true;

      settings = {
        misc = {
          api_key = { _secret = config.sops.secrets."media/api_key".path; };
          nzb_key = { _secret = config.sops.secrets."media/api_key".path; };
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
      openFirewall = true;
      encoding = {
        enableHardwareEncoding = true;
        hardwareAccelerationType = "vaapi";
        vaapiDevice = "/dev/dri/renderD128";
      };
      users = {
        shaw = {
          mutable = false;
          policy.isAdministrator = true;
          password = { _secret = config.sops.secrets."media/password".path; };
        };
      };
    };

    jellyseerr = {
      enable = true;
      openFirewall = true;
      apiKey = { _secret = config.sops.secrets."media/api_key".path; };
    };
  };
}
