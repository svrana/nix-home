{ config, pkgs, lib, inputs, ... }:
let
  colors = config.my.theme;
  spotify-cleanup = pkgs.writeShellApplication {
    excludeShellChecks = [ "SC2086" "SC2068" ];
    name = "spotify-cleanup";
    runtimeInputs = with pkgs; [ pulseaudio pipewire gnugrep coreutils ];
    text = builtins.readFile ./scripts/spotify-cleanup.sh;
  };
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    theme =
      let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in spicePkgs.themes.default;
    colorScheme = "custom";
    customColorScheme = {
      text = colors.base07;
      subtext = colors.base06;
      sidebar-text = colors.base07;
      sidebar = colors.base01;
      main = colors.base00;
      player = colors.base01;
      card = colors.base05;
      shadow = colors.base00;
      selected-row = colors.base07;
      button = colors.base0E;
      button-active = colors.base0E;
      button-disabled = colors.base05;
      tab-active = colors.base0E;
      notification = colors.base0E;
      notification-error = colors.base08;
      misc = colors.base05;
    };
  };

  services.spotifyd = {
    enable = false;
    settings = {
      global = {
        username = "shaversports";
        password_cmd = "${pkgs.gopass}/bin/gopass show --password spotify.com";
      };
    };
  };

  systemd.user.services.spotify-cleanup = {
    Unit = {
      Description = "Cleanup Spotify's leaked pulse objects";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe spotify-cleanup}";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # spotify leaks pulse objects like it's going out of style. as a result, once
  # pipewire-pulse reaches its maximum number of clients things that use
  # pipewire-pulse will start to fail. Work around by removing all but the most
  # recent spotify pulse objects.
  systemd.user.timers.spotify-cleanup = {
    Unit.Description = "Cleanup Spotify's leaked pulse objects";
    Timer = {
      Unit = "spotify-cleanup";
      OnBootSec = "30m";
      OnUnitActiveSec = "30m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
