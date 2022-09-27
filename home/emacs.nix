{ pkgs, ... }:
{
  home.packages = [
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [ epkgs.vterm ]))
  ];

  services.emacs.package = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [ epkgs.vterm ]));
}
