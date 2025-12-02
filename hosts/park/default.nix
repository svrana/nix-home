{ ... }:

{
  config.my = {
    waybar = {
      interfaces = "wlp3s0";
    };
  };

  config.home.stateVersion = "25.11";
  imports = [ ../../home ];
}
