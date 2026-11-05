{ pkgs, config, ... }:
{
  sops.secrets = {
    "media/password" = {};
    "media/api_key" = {};
    "jellyfin/api_key" = {};
    "seerr/api_key" = {};
    "lidarr/api_key" = {};
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

    nginx.enable = false;
    postgres.enable = false;

    sonarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."media/api_key".path;
        hostConfig.password._secret = config.sops.secrets."media/password".path;
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."media/api_key".path;
        hostConfig.password._secret = config.sops.secrets."media/password".path;
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    lidarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."lidarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."media/password".path;
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."media/api_key".path;
        hostConfig.password._secret = config.sops.secrets."media/password".path;
        indexers = [
          {
            name = "NZBgeek";
            apiKey._secret = config.sops.secrets."indexer-api-keys/nzbgeek".path;
          }
        ];
      };
    };

    usenetClients.sabnzbd = {
      enable = true;
      openFirewall = true;
      reverseProxy.expose = false;

      settings = {
        misc = {
          api_key._secret = config.sops.secrets."media/api_key".path;
          nzb_key._secret = config.sops.secrets."media/api_key".path;
        };

        servers = [
          {
            name = "newshosting";
            host = "news.newshosting.com";
            port = 563;
            username._secret = config.sops.secrets."usenet/newshosting/username".path;
            password._secret = config.sops.secrets."usenet/newshosting/password".path;
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
          password._secret = config.sops.secrets."media/password".path;
        };
      };
      apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
      plugins = {
        "Intro Skipper" = {
          enable = true;
          config = {
            ExcludeSeries = "";
            AutoDetectIntros = true;
            AnalyzeSeasonZero = false;
            PreferChromaprint = false;
            CacheFingerprints = true;
            UseAlternativeBlackFrameAnalyzer = false;
            UpdateMediaSegments = true;
            RebuildMediaSegments = true;
            ScanIntroduction = true;
            ScanCredits = true;
            ScanRecap = true;
            ScanPreview = true;
            ScanCommercial = false;
            AnalysisPercent = "25";
            AnalysisLengthLimit = "10";
            FullLengthChapters = false;
            SkipFirstEpisode = false;
            SkipFirstEpisodeAnime = false;
            MinimumIntroDuration = "15";
            MaximumIntroDuration = "120";
            MinimumCreditsDuration = "15";
            MaximumCreditsDuration = "450";
            MaximumMovieCreditsDuration = "900";
            MinimumRecapDuration = "15";
            MaximumRecapDuration = "120";
            MinimumPreviewDuration = "15";
            MaximumPreviewDuration = "120";
            MinimumCommercialDuration = "15";
            MaximumCommercialDuration = "120";
            BlackFrameMinimumPercentage = "85";
            BlackFrameThreshold = "28";
            UseChapterMarkersBlackFrame = true;
            AdjustIntroBasedOnChapters = true;
            AdjustIntroBasedOnSilence = true;
            SnapToKeyframe = true;
            EndSnapThreshold = "2";
            AdjustWindowInward = "5";
            AdjustWindowOutward = "2";
            ChapterAnalyzerIntroductionPattern = "(^|\\s)(Intro|Introduction|OP|Opening)(?!\\sEnd)(\\s|$)";
            ChapterAnalyzerEndCreditsPattern = "(^|\\s)(Credits?|ED|Ending|Outro)(?!\\sEnd)(\\s|$)";
            ChapterAnalyzerPreviewPattern = "(^|\\s)(Preview|PV|Sneak\\s?Peek|Coming\\s?(Up|Soon)|Next\\s+(time|on|episode)|Extra|Teaser|Trailer)(?!\\sEnd)(\\s|:|$)";
            ChapterAnalyzerRecapPattern = "(^|\\s)(Re?cap|Sum{1,2}ary|Prev(ious(ly)?)?|(Last|Earlier)(\\s\\w+)?|Catch[ -]up)(?!\\sEnd)(\\s|:|$)";
            ChapterAnalyzerCommercialPattern = "(^|\\s)(Ad(vert(isement)?)?|Commercial)(?!\\sEnd)(\\s|$)";
            IntroEndOffset = "0";
            IntroStartOffset = "0";
            MaximumFingerprintPointDifferences = 6;
            MaximumTimeSkip = 3.5;
            InvertedIndexShift = 2;
            SilenceDetectionMaximumNoise = "-50";
            SilenceDetectionMinimumDuration = "0.33";
            MaxParallelism = "2";
            ProcessThreads = "0";
            ProcessPriority = "BelowNormal";
            UseFileTransformationPlugin = false;
            SkipbuttonHideDelay = "8";
            EnableMainMenu = true;
            FileTransformationPluginEnabled = false;
          };
        };
      };
    };

    seerr = {
      enable = true;
      openFirewall = true;
      apiKey._secret = config.sops.secrets."seerr/api_key".path;
    };
  };
}
