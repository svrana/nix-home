{ ... }:
{
  services.paperless = {
    enable = true;
    address = "0.0.0.0"; # port 28981
    database.createLocally = true;
    configureTika = false; # duplicate bind (forgejo
  };
}
