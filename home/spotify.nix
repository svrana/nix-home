{ config, pkgs, home, lib, spicetify-nix, ... }:
{
  imports = [ spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    enable = true;
    theme =
      let spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
      in spicePkgs.themes.Default;
    colorScheme = "custom";
    # color definition for custom color scheme. (solarized dark)
    customColorScheme = {
      text = "fdf6e3";
      subtext = "eee8d5";
      sidebar-text = "fdf6e3";
      sidebar = "073642";
      main = "002b36";
      player = "073642";
      card = "93a1a1";
      shadow = "002b36";
      selected-row = "fdf6e3";
      button = "6c71c4";
      button-active = "6c71c4";
      button-disabled = "93a1a1";
      tab-active = "6c71c4";
      notification = "6c71c4";
      notification-error = "dc322f";
      misc = "BFBFBF";
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
}
