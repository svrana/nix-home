{ pkgs, ... }:
{
  # gotta enable this in global config to make sway run
  programs.sway.enable = true;

  # for screen sharing
  xdg.portal = {
    enable = true;
    config.common.default = "*"; # first portal implementation found (lexigraphical),w
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
