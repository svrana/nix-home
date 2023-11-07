{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopass
  ];

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
  };

  programs.bash.shellAliases = {
    "pass" = "gopass";
  };
}
