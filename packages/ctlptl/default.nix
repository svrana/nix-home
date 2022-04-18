{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "li+WwDmJ5aKmKVg8n/gWmJSBafDa4WLSNitIVBk0ZOY=";
  };

  vendorSha256 = "JpCpyjH4XhPPzgUv/yICVR1p7jV7bOIVbKHe28i+Hgc=";

  ldFlags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with pkgs.lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}
