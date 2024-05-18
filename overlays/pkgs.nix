final: prev: rec {
  system-san-francisco-font = final.callPackage ../packages/system-san-francisco-font { };
  san-francisco-mono-font = final.callPackage ../packages/san-francisco-mono-font { };
  solarized-everything-css = final.callPackage ../packages/solarized-everything-css { };
}
