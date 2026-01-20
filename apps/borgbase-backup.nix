{ ... }:
{
  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/var/lib/syncthing"
      "/var/lib/minecraft"
      "/var/lib/immich"
      "/var/lib/forgejo"
      #"/var/backup/postgres"
    ];
    exclude = [
    ];
    repo = "nl64s4sl@nl64s4sl.repo.borgbase.com:repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /root/borgbackup/passphrase";
    };
    environment.BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
    compression = "auto,lzma";
    startAt = "daily";
  };
}

