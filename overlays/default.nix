self: super: rec {
  system-san-francisco-font = super.callPackage ../packages/system-san-francisco-font { };
  san-francisco-mono-font = super.callPackage ../packages/san-francisco-mono-font { };
  ctlptl = super.callPackage ../packages/ctlptl { };
  neovim = super.callPackage ./neovim.nix { };
  powerline-go = super.callPackage ./powerline-go.nix { };
}
