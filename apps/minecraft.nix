{ ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    #serverPort = 25565;
    declarative = true;
    whitelist = {
      nightmearx = "49b6a142-833a-4543-bc4c-d3143c1a7702";
      ceralorc =  "0359cb72-216b-4f89-b0b2-27f2698784c5";
    };
    serverProperties = {
      white-list = true;
      allow-cheats = true;
    };
  };
}

