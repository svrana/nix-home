{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    coreutils
    dnsutils
    fd
    file
    gcc
    gdb
    gnumake
    htop
    nfs-utils
    openssl
    usbutils
    pciutils
    psmisc
    lsof
    lshw
    jq
    vim
    man
    openvpn
    ripgrep
    tailscale
    wget
    wirelesstools
    unzip
    zip
  ];
}

