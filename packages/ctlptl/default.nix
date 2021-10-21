{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vass9vdrl90q809gf886hijk85653is4v5f249zzif8iy00haj9";
  };

  vendorSha256 = "0y43mnqshlc6x28v0z7wnb76irz9lf1sg27y332aq9z55sbsgwmc";

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
  ];

  meta = with pkgs.lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}
