{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopass
  ];

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
  };

  programs.bash.shellAliases = {
    "pass" = "gopass";
  };
}
