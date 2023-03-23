{ pkgs, lib, ... }:
let
  docker-cleaner = pkgs.writeScript "docker-cleaner" ''
    #!/bin/sh

    set -eu
    ${pkgs.docker}/bin/docker container prune --filter "until=120h" -f
    ${pkgs.docker}/bin/docker image prune -a -f
    ${pkgs.docker}/bin/docker volume prune -f
  '';
in
{
  systemd.user.services."docker-prune" = {
    Service = {
      Type = "oneshot";
      ExecStart = "${docker-cleaner}";
    };
  };

  systemd.user.timers."docker-prune" = {
    Unit = { Description = "clean up unused resources created by docker"; };
    Install = { WantedBy = [ "timers.target" ]; };
    Timer = {
      OnCalendar = "weekly";
      Persistent = "true";
      Unit = "docker-prune.service";
    };
  };
}
