{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x4vrirwyagrwpccy1spwl38zcbs7sc0xivrhq1jhwkn654837xd";
  };

  vendorSha256 = "18fb09xjknq3gz5z990qwpqnxhnpzrydyq95aax5ldab9q7in1i1";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}
