{ config, pkgs, home, lib, ... }:

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
  #imports = [ (import "${spicetify}/module.nix") ];

  home.packages = [ pkgs.spotify ];
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
