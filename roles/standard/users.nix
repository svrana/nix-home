{ pkgs, ... }:
{
  users.users.shaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    shell = pkgs.bash;
    initialPassword = "shaw";
  };
}
