[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# nix-home

[Nix](https://nixos.org) configuration for the machines I use.

## Software used

1. flakes
2. [home-manager](https://github.com/nix-community/home-manager). (stand-alone)
3. wayland
4. [deploy-rs](https://github.com/serokell/deploy-rs) for server deployment (bocana)

## Machines

* prentiss
* bocana - server, syncthing and others
* park - dev machine

## Operations

All operations are documented in the [Makefile](./Makefile)

To deploy system configuration:

```
make system
```

To deploy the home (dotfile) configuration:

```
make home
```

### Server hosts are deployed with deploy-rs

```
deploy .#bocana
```

builds and pushes the config to bocana.
