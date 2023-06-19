{ pkgs, config, ... }:
{
  options.services.borgbackup.jobs =  {
    borgbase_backup = { # for a local backup
        # Root backing each day up to a remote backup server. We assume that you have
        #   * created a password less key: ssh-keygen -N "" -t ed25519 -f /path/to/ssh_key
        #     best practices are: use -t ed25519, /path/to = /run/keys
        #   * the passphrase is in the file /run/keys/borgbackup_passphrase
        #   * you have initialized the repository manually
        paths = [ "/var/lib/syncthing" ];
        exclude = [];
        doInit = false;
        repo =  "user3@arep.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /run/keys/id_ed25519_borgbase.pub";
        };
        environment = { BORG_RSH = "ssh -i /run/keys/id_ed25519_borgbase.pub"; };
        compression = "auto,lzma";
        startAt = "daily";
      };
    };
}

