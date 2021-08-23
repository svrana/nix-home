let
  sources = import ./nix/sources.nix;
  nixPath = import ./nix-path.nix;
in
{
  pkgs ? import sources.nixpkgs { }
}:
pkgs.stdenv.mkDerivation {
  name = "dots";
  NIX_PATH = builtins.concatStringsSep ":" nixPath;
  buildInputs = [
    pkgs.niv
    (import sources.home-manager { inherit pkgs; }).home-manager
    (pkgs.writeShellScriptBin "nixos-rebuild-pretty" ''
      sudo -E sh -c "nixos-rebuild $@"
      # prettier than nixos-rebuild switch (this courtesty github.com/meatcar/dots)
      #sudo -E sh -c "nix build --experimental-features nix-command --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && nixos-rebuild $@"
      #sudo -E sh -c "nix build --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && nixos-rebuild $@"
    '')
    (pkgs.writeShellScriptBin "hm" ''
      home-manager -I ${builtins.concatStringsSep " -I " nixPath} -f "$DOTFILES/hosts/$HOSTNAME" "$@"
    '')
  ];
}
