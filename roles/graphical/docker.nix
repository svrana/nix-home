{ ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  # Required because /run/user/1000 tempfs is too small for docker
  services.logind.extraConfig = ''
    RuntimeDirectorySize=8G
  '';
}
