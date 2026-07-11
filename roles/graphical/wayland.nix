{ pkgs, ... }:
{
  # gotta enable this in global config to make sway run
  programs.sway.enable = true;

  # for screen sharing
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast.max_fps = 30;
    };
  };
}
