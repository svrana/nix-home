{ pkgs, config, ... }:
{
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    database.enableVectors - false;
    #port = 2283;
  };
}
