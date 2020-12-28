{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopass
  ];

  programs.bash.sessionVariables = {
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
  };

  programs.bash.shellAliases = {
    "pass" = "gopass";
  };
}
