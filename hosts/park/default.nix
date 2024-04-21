{ ... }:

{
  config.my = {
    waybar = {
      interfaces = "wlp3s0";
    };
  };

  home.stateVersion = "21.03";
  imports = [ ../../home ];
}
