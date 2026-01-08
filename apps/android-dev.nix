{ ... }:
{
  programs.adb.enable = true;
  users.users.shaw.extraGroups = [ "adbusers" ];
}
