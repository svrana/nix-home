{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FJtp4g4kIkXFYvYcM9yF3BY6tgHmip11/oIyMSfTwqM=";
  };

  vendorSha256 = "sha256-s+Cc7pG/GLK0ZhXX/wK7jMNcDIeu/Am2vCgzrNXKpdw=";

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
