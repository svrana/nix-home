{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buf-language-server";
  version = "6f08a7eed22c5a178cb55613f454319e09be112c";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = version;
    sha256 = "sha256-UHsWrWDOC/f3YS2g533CgUkuUmz4MUQRunClQiY/YPQ=";
  };

  vendorSha256 = "sha256-ORzCOmBx6k1GZj6pYLhqPsdneCc7Tt1yHpI5mw5ruFU=";

  meta = with pkgs.lib; {
    description = "Language server for protocol buffers";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}

