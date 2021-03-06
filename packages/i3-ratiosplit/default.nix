{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "i3-ratiosplit";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "333fred";
    repo = pname;
    rev = "v${version}";
    sha256 = "111hzzml04njhfa033v98m4yd522zj91s6ffvrm0m6sk7m0wyjsc";
  };

  #cargoSha256 = "0jmmxld4rsjj6p5nazi3d8j1hh7r34q6kyfqq4wv0sjc77gcpaxd";
  cargoSha256 = "1l3sjy52s5x4hxb34wvwnkcrp0kxg3drz95zfgbzqar0x7zg3bq6";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus ];
  #libpulseaudio ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Split windows to a percentage of the screen width";
    homepage = "https://github.com/333fred/i3-ratiosplit";
    license = licenses.gpl3;
    maintainers = with maintainers; [ svrana ];
    platforms = platforms.linux;
  };
}
