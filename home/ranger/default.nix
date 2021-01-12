{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./rc.conf;
  xdg.configFile."ranger/scope.sh".source = ./scope.sh;

  home.packages = with pkgs; [ ranger ];
}
