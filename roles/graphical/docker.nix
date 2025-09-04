{ ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  # Required because /run/user/1000 tempfs is too small for docker
  services.logind.settings.Login= {
    RuntimeDirectorySize="8G";
  };
}
