{ pkgs, ... }:
{
  # gotta enable this in global config to make sway run
  programs.sway.enable = true;

  # for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
