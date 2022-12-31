{ config, pkgs, home, lib, spicetify-nix, ... }:
let
  spotify-tui = pkgs.writeScript "spotify-tui" ''
    ${pkgs.alacritty}/bin/alacritty --title Spotify --class spotify -e ${pkgs.spotify-tui}/bin/spt
  '';
  spotify-tui-desktop-file = pkgs.writeTextFile {
    name = "spotify-tui.desktop";
    text = ''
      [Desktop Entry]
      Comment=spotify console interface
      Terminal=false
      Name=spotify-tui
      GenericName=Music Player Text User Interface
      Exec=${spotify-tui}
      Type=Application
      Icon=${pkgs.spotify}/share/spotify/icons/spotify-linux-256.png
    '';
  };
in
{
  imports = [ spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    enable = true;
    theme = "catppuccin-mocha";
    # enabledExtensions = [
    #   "fullAppDisplay.js"
    #   "shuffle+.js"
    # ];
    #
    # spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
    #   pname = "spicetify-cli";
    #   version = "2.9.9";
    #   src = pkgs.fetchgit {
    #     url = "https://github.com/spicetify/${pname}";
    #     rev = "v${version}";
    #     sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
    #   };
    #});

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
    enable = true;
    settings = {
      global = {
        username = "shaversports";
        password_cmd = "${pkgs.gopass}/bin/gopass show --password spotify.com";
      };
    };
  };

  xdg.dataFile."applications/spotify-tui.desktop".source = "${spotify-tui-desktop-file}";
  xdg.configFile."spotify-tui/config.yml".text = ''
    theme:
      selected: Cyan
  '';
}
