{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "solarized-everything-css";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "${name}";
    rev = "bea989070bbb1389ca05e67118786beb55321e55";
    sha256 = "pwl2B0hYrzGGsSicVs/amu+N0Txd1e3+4+LKyWpyTeI=";
  };

  configurePhase = ''
    rm Makefile
  '';
  installPhase = ''
    mkdir -p $out/share/css
    cp css/solarized-dark/solarized-dark-all-sites.css $out/share/css
    cp css/solarized-light/solarized-light-all-sites.css $out/share/css
  '';

  meta = {
    description = "Solarize the web";
    homepage =  "https://github.com/alphapapa/solarized-everything-css";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
