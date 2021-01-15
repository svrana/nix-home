{ pkgs, ... }:
let
  insync = "${pkgs.insync}/bin/insync";
in
{
  systemd.user.services.insync = {
    Unit = {
      Description = "insync google drive fs synchronization";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "forking";
      ExecStart = "${insync} start";
      Restart = "on-failure";
      ExecStop = "${insync} stop";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
