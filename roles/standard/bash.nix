{ ... }:
{
  programs.bash.interactiveShellInit = "set -o vi";
  programs.bash.shellAliases = {
    "jctl" = "journalctl";
    "sctl" = "systemctl";
  };
}
