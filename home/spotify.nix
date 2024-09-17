{ config, pkgs, inputs, ... }:
let
  colors = config.my.theme;
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

  services.spotify-cleanup = {
    enable = true;
    interval = "30m";
  };
}
