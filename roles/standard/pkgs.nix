{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    coreutils
    dnsutils
    fd
    file
    gcc
    gdb
    gnumake
    htop
    jq
    lshw
    lsof
    man
    nfs-utils
    openssl
    pciutils
    psmisc
    ripgrep
    tailscale
    tcpdump
    unzip
    usbutils
    wget
    wirelesstools
    unixtools.netstat
    zip
  ];
}

