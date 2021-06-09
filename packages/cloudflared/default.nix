{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2021.5.10";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "${version}";
    sha256 = "1wksbl93mcdvx46s15xbrakldnq7s71m6w9b013zhk1plals3xxz";
  };

  vendorSha256 = null;

  buildFlagsArray = [
      "-ldflags=-X main.Version=${version}"
  ];

  meta = with pkgs.lib; {
    description = "Command line client for argo tunnel, a tunneling daemon that proxies any local webserver through the Cloudflare network";
    license = licenses.asl20; # not listed....which is why i haven't upstream this.. need
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}
