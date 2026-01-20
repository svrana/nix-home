{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
  };

  # services.postgresqlBackup = {
  #   enable = false;
  #   startAt = "*-*-* *:15:00";
  #   pgdumpOptions = "--no-owner";
  #   databases = [
  #     "immich"
  #   ];
  # };
}
