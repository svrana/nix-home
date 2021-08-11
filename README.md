[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# nixos-configs

[Nix](https://nixos.org) configuration for the machines I use.

I manage my user configuration with [home-manager](https://github.com/nix-community/home-manager). I do not configure
home-manager as a module as I frequently make configuration changes for which I do not want boot entries.

## Versioning

Packages are pinned with with [niv](https://github.com/nmattia/niv).

## Operations


All operations are documented in the [Makefile](./Makefile)

To deploy system configuration:

```
make system
```

To deploy the home (dotfile) configuation:

```
make home
```

To deploy the other machines on my home network, I use [morph](https://github.com/DBCDK/morph) via the command

```
make vnet
```
