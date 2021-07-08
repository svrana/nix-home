{ config, pkgs, ... }:
{
  users.users.shaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      # Replace this with your SSH key!
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7KJj8dIsnQcamDoHUcYbIlvxKsd6RqqjNhEBdVeCfr7tfxEzRcUf+1WlGSBV6w0Z30e2oJLSJFhV08+WzBAo76OfNn2rFm+v5ppRo+m0SLzzzQs5Ha2ac0xnGQmxHCHKCf8V2Hqfc4dYog1L8aEJWJAmbrzsesam/SCsvwHnoSqElbScbirXJjuXwFx4UjevMJC7dU123Q9Qfj3zeuHjDzgzSDR0BpUFAVR0aYCie4M/bmKm1pAmAlKCDRmSwptRp3zX9My+H2VyCgeAqMABvy+DqkEA/U478OR+DmjA+zI2XePx8aea561OJaQKCbuf/Q4WqZODH70bCn95V7VYW+FmQCnVfJuuz9AV/ujqRCkGeIhwBHvWcVn6zqWlpxe18Kcsj+zzLmLVA8Hs8dPSplTV+X+Zq8rZmCPU+2rAH19kaRZRh6U+2wl3dexDDolE/ucFuaQBgR5fMtP2xgAWd1HjjTz2Caor29+Uv59HTdptagpUUaUUSnGaZBubcOxb/KLi1xPyvZxhfe9k1OawKL6E5qk7glYWYtXCmVh5s54OTj3QdBcLeN0dXBN+xWLntfF3kI6vaWn6tw7v5iJaJ7yIsjO0yMNgA3fgy5nTgMBtEZ8TIH7pn7hC80P3qT4lW+PicxASfoY8jq3LZEHI5vkIuRskGmE1nS7GMu8R+HQ== shaw@vranix.com"
    ];
  };
  # Use my ssh keys for logging in as root
  users.users.root.openssh.authorizedKeys.keys = config.users.users.shaw.openssh.authorizedKeys.keys;
}
