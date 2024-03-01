{ pkgs, ... }:
{
  # use home-manager sway
  #programs.sway.enable = true;

  # for screen sharing
  xdg.portal = {
    enable = true;
    config.common.default = "*"; # first portal implementation found (lexigraphical),w
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
