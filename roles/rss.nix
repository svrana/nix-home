{ pkgs, ... }:
{
  services.postgresql = {
    ensureDatabases = [ "tt_rss" ];
  };

  services.tt_rss = {
    enable = true;
    database = {
      name = "tt_rss";
      user = "tt_rss";
      password = "foofarfaz";
    };
    selfUrlPath = "rss.heimlab.link";
  };
}
