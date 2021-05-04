[![NixOS 20.09](https://img.shields.io/badge/NixOS-v20.09-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

## Installation



```
sudo chown shaw:users /etc/nixos
git clone --recursive https://github.com/svrana/nix-home.git /etc/nixos
cd /etc/nixos
sudo nixos-rebuild . switch
```
