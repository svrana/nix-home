{ pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protocol-buffers-language-server";
  version = "6c789bde03b5bfdf3854a7eee725108d430f7134";

  src = fetchFromGitHub {
    owner = "micnncim";
    repo = pname;
    rev = "6c789bde03b5bfdf3854a7eee725108d430f7134";
    sha256 = "1kdf0zf5bn8bdxxqrazbmh2mnhp68l1ywfasbn9y22dgsrvlvaa0";
  };

  vendorSha256 = "1ag3a9hnc4ak7ci66s5q5rf3jpy9j2f7ya2x8vpqjbv4h1d7wyji";

  meta = with pkgs.lib; {
    description = "Language server for protocol buffers";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ svrana ];
  };
}

