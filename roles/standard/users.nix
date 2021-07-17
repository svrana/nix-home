{ config, pkgs, ... }:
{
  users.users.shaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      # Replace this with your SSH key!
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvlf6HSVgzzjal3jw/3l/0IIIl388H3AOlJswHHBS2ec6MOBDxX9KkyMTkirIKProkOCUI/uepVDfkLFUEsEZw3SQmtfHBbM1ffNqFePkbWpF+ZZKbRYy0R3FhICMmPv+UvgAvvh5/2gkHmuZ2w5egwT2CeUA5DX2pdvcdioxgJ2SeksZ27B0KzGMMNe5ULDDYnpoRV8YBq8cEQvfLtl0pv7MoWkG9chDGw5vU/En3zotrBLHfbxk50FPtZfa8d/bxBICW6PZgWpmqJFQJSB9lxwrCMuXrMUs95bgqIEnxRKGqczHYBuYDdpy2OeNffI0TRl17YBQ3jAlSz5mpgmuHxBUHERPx0lTFj1nl7bObNMTXAdUlTLCSW30bxJ/NPG7y9TCHKegbymvv5cMWVh2iCkMCDX1jlMr56AOKBZ1zumLZwwi6ZGgXEVNBkTDToqJEwMqeSo7/rICLNW0MAD+S7fKrdK3pD3Pl5xEZV3XxIchuxJ7OVxJIybqX/x5ixn0= shaw@prentiss"
    ];
  };
  # Use my ssh keys for logging in as root
  users.users.root.openssh.authorizedKeys.keys = config.users.users.shaw.openssh.authorizedKeys.keys;
}
