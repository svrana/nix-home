{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fagxd1wgnfq452la4na49hz9kss2sgh6ljkpwi0x54viyxbja5b";
  };

  vendorSha256 = "18fb09xjknq3gz5z990qwpqnxhnpzrydyq95aax5ldab9q7in1i1";

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
  ];

  meta = with stdenv.lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}
