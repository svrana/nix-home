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
    wget
    wirelesstools
    unzip
    zip
  ];
}

