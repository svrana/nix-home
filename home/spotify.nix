{ config, pkgs, home, lib, spicetify-nix, ... }:
let
  #spicetify = fetchTarball https://github.com/pietdevries94/spicetify-nix/archive/master.tar.gz;
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

  home.packages = [ pkgs.spotify ];

  programs.spicetify = {
    enable = true;
    theme = "catppuccin-mocha";
    # OR
    # theme = spicetify-nix.pkgs.themes.catppuccin-mocha;
    colorScheme = "flamingo";
    #theme = spicetify-nix.pkgs.themes.Dribbblish;
    # theme = "catppuccin-mocha";
    # OR
    # theme = spicetify-nix.pkgs.themes.catppuccin-mocha;
    #injectCss = true;
    #replaceColors = true;
    #overwriteAssets = true;
    #sidebarConfig = true;

    # enabledExtensions = [
    #   "fullAppDisplay.js"
    #   "shuffle+.js"
    #   "hidePodcasts.js"
    # ];
    spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (oa: rec {
      pname = "spicetify-cli";
      version = "2.9.9";
      src = pkgs.fetchgit {
        url = "https://github.com/spicetify/${pname}";
        rev = "v${version}";
        sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
      };
    });

  };

  # programs.spicetify = {
  #   enable = false;
  #   theme = "Ziro";
  #   injectCss = true;
  #   replaceColors = true;
  #   overwriteAssets = true;
  #
  # };

  #home.packages = [ pkgs.spotify ];
  # programs.spicetify = {
  #   enable = false;
  #   theme = "SolarizedDark";
  #   injectCss = true;
  #   replaceColors = true;
  #   overwriteAssets = true;
  # };

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
